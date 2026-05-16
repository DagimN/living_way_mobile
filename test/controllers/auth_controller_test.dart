import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/core/models/profile.dart';
import 'package:living_way/core/services/cache_service.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import '../helpers/api_test_helpers.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  group('AuthController', () {
    test('init loads login flags from cache', () async {
      await CacheService.instance.writeData('isLoggedIn', true);
      await CacheService.instance.writeData('isLoggedInViaManual', true);

      final controller = AuthController();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoggedIn, isTrue);
      expect(controller.isLoggedInViaManual, isTrue);
    });

    test('performLogin stores profile on success', () async {
      final profile = sampleProfileJson();
      final dio = createMockApiDio(routes: {
        '/auth/login': MockResponse(
          statusCode: 200,
          data: {'data': profile},
        ),
      });

      final profileController = ProfileController();
      final auth = AuthController(dio: dio)
        ..setProfileController = profileController;

      final success =
          await auth.performLogin('john@example.com', isOAuth: true);

      expect(success, isTrue);
      expect(profileController.userProfile?.firstName, 'John');
    });

    test('performLogin returns false on network error', () async {
      final dio = createMockApiDio();
      final auth = AuthController(dio: dio);
      final success = await auth.performLogin('fail@example.com');

      expect(success, isFalse);
    });

    test('performSignup clears progress and caches profile on success', () async {
      final profile = sampleProfileJson(firstName: 'Jane');
      final dio = createMockApiDio(routes: {
        '/auth/signup': MockResponse(
          statusCode: 201,
          data: {'data': profile},
        ),
      });

      final profileController = ProfileController();
      final auth = AuthController(dio: dio)
        ..setProfileController = profileController
        ..signupProgress.firstName = 'Jane'
        ..signupProgress.lastName = 'Doe'
        ..signupProgress.email = 'jane@example.com'
        ..signupProgress.password = 'password123';

      final response = await auth.performSignup();

      expect(response.statusCode, 201);
      expect(auth.signupProgress.firstName, isNull);
      expect(profileController.userProfile?.firstName, 'Jane');

      final isLoggedIn = await CacheService.instance.readData<bool>(
        'isLoggedIn',
        defaultValue: false,
      );
      expect(isLoggedIn, isTrue);
    });

    test('logoutViaManual clears session cache', () async {
      await CacheService.instance.writeData('isLoggedIn', true);
      await CacheService.instance.writeData('isLoggedInViaManual', true);
      await CacheService.instance.writeData('profile', '{"id":"1"}');

      final auth = AuthController();
      await auth.logoutViaManual();

      expect(
        await CacheService.instance.readData<bool>(
          'isLoggedIn',
          defaultValue: true,
        ),
        isFalse,
      );
    });
  });
}
