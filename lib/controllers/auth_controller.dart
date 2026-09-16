import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/controllers/controllers.dart';

class AuthController extends ChangeNotifier {
  static const _accessTokenKey = "accessKey";
  static const _refreshTokenKey = "refreshKey";

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final url = appFlavor == "dev"
      ? Urls.devApiUrl
      : appFlavor == "staging"
          ? Urls.stagingApiUrl
          : Urls.prodApiUrl;
  late final dio = Dio(BaseOptions(
      baseUrl: '$url/api/v1/auth',
      connectTimeout: const Duration(seconds: 15)));

  bool isLoggedIn = false;
  bool isLoggedInViaGoogle = false;
  bool isLoggedInViaManual = false;
  SignupProgress signupProgress = SignupProgress();
  ProfileController? profileController;

  AuthController() {
    init();
  }

  Future<void> init() async {
    isLoggedIn = await CacheService.instance
        .readData<bool>('isLoggedIn', defaultValue: false);
    isLoggedInViaGoogle = await CacheService.instance
        .readData<bool>('isLoggedInViaGoogle', defaultValue: false);
    isLoggedInViaManual = await CacheService.instance
        .readData<bool>('isLoggedInViaManual', defaultValue: false);
    notifyListeners();

    await refreshTokens();
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _secureStorage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() =>
      _secureStorage.read(key: _refreshTokenKey);

  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }

  set setProfileController(ProfileController value) {
    profileController = value;
  }

  Future<bool> loginViaGoogle() async {
    try {
      final account =
          await GoogleSignIn(serverClientId: googleClientId).signIn();

      if (account == null) {
        logger.e('Could not login via Google - account is null');
        UIService.showSnackbar(
            backgroundColor: Colors.red, message: Tr.t('failedGoogleLogin'));
        return false;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        logger.e('Could not login via Google - idToken is null');
        UIService.showSnackbar(
            backgroundColor: Colors.red, message: Tr.t('failedGoogleLogin'));
        return false;
      }

      final response = await dio.get('/google', queryParameters: {
        "idToken": idToken,
      });

      if (!response.statusCode.isSuccess) {
        UIService.showSnackbar(
            backgroundColor: Colors.red, message: Tr.t('failedGoogleLogin'));
        return false;
      }

      final accessToken = response.data['accessToken'];
      await saveTokens(
          accessToken: accessToken,
          refreshToken: response.data['refreshToken']);
      profileController?.setUserProfile =
          Profile.fromJson({...response.data['user'], "tokenId": accessToken});
      await AnalyticsService.logLogin('google');
      await CacheService.instance.writeData<String>('profile',
          json.encode({...response.data['user'], "tokenId": accessToken}));
      await CacheService.instance.writeData<bool>('isLoggedIn', true);
      await CacheService.instance.writeData<bool>('isLoggedInViaGoogle', true);
      isLoggedIn = true;
      isLoggedInViaGoogle = true;
      isLoggedInViaManual = false;
      notifyListeners();

      return true;
    } catch (error) {
      logger.e(error);

      UIService.showSnackbar(
          backgroundColor: Colors.red, message: Tr.t('failedGoogleLogin'));

      return false;
    }
  }

  Future<Response> register() async {
    try {
      final response = await dio.post('/signup', data: {
        "firstName": signupProgress.firstName,
        "lastName": signupProgress.lastName,
        "email": signupProgress.email,
        "password": hash(signupProgress.password!),
      });

      if (!response.statusCode.isSuccess) return response;

      signupProgress = SignupProgress();

      final data = response.data['user'];
      profileController?.setUserProfile = Profile.fromJson(data);

      await CacheService.instance
          .writeData<String>('profile', json.encode(data));
      await AnalyticsService.logSignUp('manual');
      await CacheService.instance.writeData<bool>('isLoggedIn', true);
      await CacheService.instance.writeData<bool>('isLoggedInViaManual', true);

      return response;
    } on DioException catch (error) {
      UIService.showSnackbar(
          backgroundColor: Colors.red, message: Tr.t('failedSignup'));
      logger.e(error);
      return error.response ??
          Response(
              requestOptions: RequestOptions(),
              statusCode: 400,
              statusMessage: error.toString());
    } on Exception catch (error) {
      logger.e(error);
      return Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          statusMessage: error.toString());
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      final response =
          await dio.get('/password/forgot', queryParameters: {'email': email});

      return response.statusCode.isSuccess;
    } catch (error) {
      logger.e(error);
      return false;
    }
  }

  Future<bool> loginViaManual(String email, String password) async {
    try {
      final response = await dio
          .post('/login', data: {"email": email, "password": password});

      final accessToken = response.data['accessToken'];
      profileController?.setUserProfile =
          Profile.fromJson({...response.data['user'], "tokenId": accessToken});
      await saveTokens(
        accessToken: accessToken,
        refreshToken: response.data['refreshToken'],
      );
      await CacheService.instance.writeData<String>('profile',
          json.encode({...response.data['user'], "tokenId": accessToken}));

      await AnalyticsService.logLogin('manual');
      isLoggedIn = true;
      isLoggedInViaGoogle = false;
      isLoggedInViaManual = true;
      notifyListeners();

      return true;
    } on DioException catch (error) {
      final response = error.response;

      if (response?.statusCode == StatusCode.unauthorizedHttp401) {
        UIService.showSnackbar(
            backgroundColor: Colors.red,
            message: "Incorrect email or password");
      }
      logger.e(error);
      return false;
    } catch (error) {
      logger.e(error);

      return false;
    }
  }

  Future<void> logoutViaGoogle() async {
    await GoogleSignIn().signOut();
    await CacheService.instance.deleteData('profile');
    await CacheService.instance.writeData('isLoggedIn', false);
    await CacheService.instance.writeData('isLoggedInViaGoogle', false);
    await clearTokens();

    isLoggedIn = false;
    isLoggedInViaGoogle = false;
    notifyListeners();
  }

  Future<void> logoutViaManual() async {
    await CacheService.instance.deleteData('profile');
    await CacheService.instance.writeData<bool>('isLoggedIn', false);
    await CacheService.instance.writeData<bool>('isLoggedInViaManual', false);
    await clearTokens();

    isLoggedIn = false;
    isLoggedInViaManual = false;
    notifyListeners();
  }

  Future<void> refreshTokens() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return;
      }
      final response = await dio.get('/refresh', queryParameters: {
        "refreshToken": refreshToken,
      });

      if (!response.statusCode.isSuccess) {
        logger.e('Could not refresh tokens - ${response.statusCode}');
        return;
      }

      final accessToken = response.data['accessToken'];
      profileController?.setUserProfile =
          Profile.fromJson({...response.data['user'], "tokenId": accessToken});
      await saveTokens(
        accessToken: accessToken,
        refreshToken: response.data['refreshToken'],
      );
      await CacheService.instance.writeData<String>('profile',
          json.encode({...response.data['user'], "tokenId": accessToken}));
    } catch (error) {
      clearTokens();
      profileController?.clearValues();
      logger.e(error);
    }
  }
}
