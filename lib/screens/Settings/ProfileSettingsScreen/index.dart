import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/AuthScreens/login_screen.dart';
import 'package:provider/provider.dart';

import '../MapScreen/index.dart';
import '../MapScreen/widgets/places_autocomplete_field.dart';
import 'widgets/prompt_logout_dialog.dart';
import 'widgets/password_update_dialog.dart';
import 'widgets/prompt_delete_profile_dialog.dart';
import 'widgets/setting_option_tile.dart';
import 'widgets/verify_email_message.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final placesService = GooglePlacesService();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  PlaceDetails? place;

  bool isUpdatingAnonymous = false;
  bool isUpdatingProfileImage = false;
  bool isUpdatingName = false;
  bool isUpdatingPhone = false;
  bool isUpdatingAddress = false;

  String? _validateName(String? value, String errorKey) {
    if (value == null || value.trim().isEmpty) {
      return Tr.t(errorKey);
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    final phoneNumber = value?.trim() ?? '';
    if (phoneNumber.isEmpty) {
      return null;
    }

    final hasValidFormat =
        RegExp(r'^\+?[0-9](?:[0-9\s().-]*[0-9])?$').hasMatch(phoneNumber);
    final digitCount = phoneNumber.replaceAll(RegExp(r'\D'), '').length;
    if (!hasValidFormat || digitCount < 7 || digitCount > 15) {
      return Tr.t('invalidPhoneNumber');
    }

    return null;
  }

  @override
  void dispose() {
    addressController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    addressFocusNode.dispose();
    placesService.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final context = UIService.navigatorKey.currentContext;

    if (context != null) {
      final profileController = Provider.of<ProfileController>(context);
      final profile = profileController.userProfile;

      if (profile != null) {
        firstNameController.text = profile.firstName;
        lastNameController.text = profile.lastName;
        phoneNumberController.text = profile.phoneNumber ?? '';
        addressController.text = profile.address ?? '';
        place = PlaceDetails(
            address: profile.address, coordinates: profile.coordinates);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double imageSize = 128.0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    final theme = Provider.of<ThemeController>(context).theme;

    final authController = Provider.of<AuthController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final profile = profileController.userProfile;
    final imageProvider = profile?.profileImageUrl != null
        ? CachedNetworkImageProvider(profile?.profileImageUrl ?? "")
        : null;

    if (profile == null) {
      return const LoginScreen();
    }

    if (!profile.emailVerified) {
      return Scaffold(
          backgroundColor: theme.backgroundColor,
          appBar: AppBar(
              backgroundColor: theme.backgroundColor,
              systemOverlayStyle: theme.brightness == Brightness.light
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.primaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          body: const VerifyEmailMessage());
    }

    bool areNameValuesUpdated() {
      return firstNameController.text != profile.firstName ||
          lastNameController.text != profile.lastName;
    }

    bool isPhoneNumberValuesUpdated() {
      return phoneNumberController.text != (profile.phoneNumber ?? "");
    }

    bool isCoordinatesUpdated() {
      final profileCoordinates = profile.coordinates;
      return place?.coordinates?.latitude != profileCoordinates?.latitude ||
          place?.coordinates?.longitude != profileCoordinates?.longitude;
    }

    bool isAddressValuesUpdated() {
      return addressController.text != (profile.address ?? "");
    }

    bool areValuesUpdated() {
      return areNameValuesUpdated() ||
          isPhoneNumberValuesUpdated() ||
          isAddressValuesUpdated() ||
          isCoordinatesUpdated();
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: theme.primaryColor,
          systemOverlayStyle: theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
          title: Text(Tr.t('profile'),
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w300)),
        ),
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: orientation == Orientation.portrait
                      ? screenHeight * .85
                      : screenWidth * .32,
                  child: SingleChildScrollView(
                      child: Form(
                          key: _formKey,
                          child: Column(
                              spacing: 12,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 52, 0, 16),
                                    child: Stack(children: [
                                      Stack(children: [
                                        Container(
                                            height: imageSize,
                                            width: imageSize,
                                            margin: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: theme.primaryColor
                                                          .withAlpha(51),
                                                      offset:
                                                          const Offset(0, 7),
                                                      blurRadius: 21,
                                                      spreadRadius: 1)
                                                ],
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: profile
                                                                .profileImageUrl !=
                                                            null
                                                        ? imageProvider!
                                                        : Image.asset(AppImages
                                                                .profilePlaceholder)
                                                            .image))),
                                        if (isUpdatingProfileImage)
                                          Container(
                                              height: imageSize,
                                              width: imageSize,
                                              margin: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black
                                                      .withAlpha(76)),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: theme
                                                              .primaryColor)))
                                      ]),
                                      Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: SizedBox(
                                              height: 35,
                                              width: 35,
                                              child: IconButton(
                                                  style: IconButton.styleFrom(
                                                      backgroundColor:
                                                          theme.backgroundColor,
                                                      elevation: 5,
                                                      shadowColor:
                                                          Colors.black),
                                                  onPressed: () async {
                                                    AnalyticsService.logEvent(
                                                        'profile_image_update_started');
                                                    setState(() {
                                                      isUpdatingProfileImage =
                                                          true;
                                                    });

                                                    final images =
                                                        await ImageService
                                                            .openGallery();

                                                    if (images.isNotEmpty) {
                                                      String fileName = images
                                                          .first.path
                                                          .split('/')
                                                          .last;
                                                      FormData formData =
                                                          FormData();
                                                      formData.fields.add(
                                                          MapEntry('id',
                                                              profile.id));
                                                      formData.files.add(MapEntry(
                                                          'image',
                                                          await MultipartFile
                                                              .fromFile(
                                                                  images.first
                                                                      .path,
                                                                  filename:
                                                                      fileName)));

                                                      await profileController
                                                          .editProfile(
                                                              formData);
                                                    } else {
                                                      UIService.showSnackbar(
                                                          backgroundColor:
                                                              theme.failedColor,
                                                          message: Tr.t(
                                                              'noImageSelected'));
                                                    }

                                                    setState(() {
                                                      isUpdatingProfileImage =
                                                          false;
                                                    });
                                                  },
                                                  icon: Icon(Icons.image,
                                                      color: theme.primaryColor,
                                                      size: 20))))
                                    ])),
                                TextFormField(
                                    controller: firstNameController,
                                    onTap: () => setState(() {}),
                                    style: TextStyle(color: theme.accentColor),
                                    enabled: !isUpdatingName,
                                    decoration: InputDecoration(
                                        labelText: Tr.t('firstName'),
                                        labelStyle: firstNameFocusNode.hasFocus
                                            ? null
                                            : TextStyle(
                                                color: theme.accentColor),
                                        border: const OutlineInputBorder()),
                                    validator: (value) => _validateName(
                                        value, 'firstNameRequired'),
                                    textInputAction: TextInputAction.next),
                                TextFormField(
                                    controller: lastNameController,
                                    onTap: () => setState(() {}),
                                    style: TextStyle(color: theme.accentColor),
                                    enabled: !isUpdatingName,
                                    decoration: InputDecoration(
                                        labelText: Tr.t('lastName'),
                                        labelStyle: lastNameFocusNode.hasFocus
                                            ? null
                                            : TextStyle(
                                                color: theme.accentColor),
                                        border: const OutlineInputBorder()),
                                    validator: (value) => _validateName(
                                        value, 'lastNameRequired'),
                                    textInputAction: TextInputAction.done),
                                TextFormField(
                                  controller: TextEditingController(
                                      text: profile.email),
                                  style: TextStyle(color: theme.accentColor),
                                  enabled: false,
                                  decoration: InputDecoration(
                                      labelText: Tr.t('email'),
                                      border: const OutlineInputBorder()),
                                ),
                                TextFormField(
                                    controller: phoneNumberController,
                                    onTap: () => setState(() {}),
                                    style: TextStyle(color: theme.accentColor),
                                    enabled: !isUpdatingPhone,
                                    decoration: InputDecoration(
                                        labelText: Tr.t('phoneNumber'),
                                        labelStyle:
                                            phoneNumberFocusNode.hasFocus
                                                ? null
                                                : TextStyle(
                                                    color: theme.accentColor),
                                        border: const OutlineInputBorder()),
                                    keyboardType: TextInputType.phone,
                                    validator: _validatePhoneNumber,
                                    textInputAction: TextInputAction.done),
                                PlacesAutocompleteField(
                                  controller: addressController,
                                  style: TextStyle(color: theme.accentColor),
                                  focusNode: addressFocusNode,
                                  enabled: !isUpdatingAddress,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    labelText: Tr.t('address'),
                                    labelStyle: addressFocusNode.hasFocus
                                        ? null
                                        : TextStyle(color: theme.accentColor),
                                    border: const OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      onPressed: () async {
                                        final selection = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                      create: (_) => MapController(
                                                          profile:
                                                              profileController
                                                                  .userProfile,
                                                          place: place),
                                                      child:
                                                          const MapScreen())),
                                        ) as PlaceDetails?;

                                        if (!mounted || selection == null)
                                          return;

                                        setState(() {
                                          addressController.text =
                                              selection.address ?? "";
                                          place = selection;
                                        });
                                      },
                                      icon: Icon(Icons.map,
                                          color: theme.iconColor),
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                  onPlaceSelected: (place) {
                                    setState(() {
                                      this.place = place;
                                    });
                                  },
                                ),
                                if (authController.isLoggedInViaManual)
                                  SettingOptionTile(
                                      title: Tr.t('changePassword'),
                                      onTap: () async {
                                        AnalyticsService.logEvent(
                                            'profile_change_password_opened');
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const PasswordUpdateDialog());
                                      },
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Color(0xFF413F2B)),
                                      isLast: true),
                                if (areValuesUpdated())
                                  SizedBox(
                                      width: 200,
                                      child: isUpdatingName ||
                                              isUpdatingPhone ||
                                              isUpdatingAddress
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                  color: theme.primaryColor))
                                          : ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      theme.primaryColor),
                                              onPressed: () async {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }

                                                setState(() {
                                                  isUpdatingName =
                                                      areNameValuesUpdated();
                                                  isUpdatingPhone =
                                                      isPhoneNumberValuesUpdated();
                                                  isUpdatingAddress =
                                                      isAddressValuesUpdated() ||
                                                          isCoordinatesUpdated();
                                                });

                                                FormData formData = FormData();
                                                formData.fields.add(
                                                    MapEntry('id', profile.id));
                                                formData.fields.add(MapEntry(
                                                    'firstName',
                                                    firstNameController.text));
                                                formData.fields.add(MapEntry(
                                                    'lastName',
                                                    lastNameController.text));
                                                formData.fields.add(MapEntry(
                                                    'phoneNumber',
                                                    phoneNumberController
                                                        .text));
                                                formData.fields.add(MapEntry(
                                                    'address',
                                                    addressController.text));
                                                if (place != null) {
                                                  formData.fields.add(MapEntry(
                                                    'coordinates',
                                                    jsonEncode([
                                                      place!.coordinates!
                                                          .latitude,
                                                      place!.coordinates!
                                                          .longitude,
                                                    ]),
                                                  ));
                                                }

                                                try {
                                                  final saved =
                                                      await profileController
                                                          .editProfile(
                                                              formData);
                                                  UIService.showSnackbar(
                                                      message: Tr.t(saved
                                                          ? 'updateSuccess'
                                                          : 'updateFailed'),
                                                      backgroundColor: saved
                                                          ? theme.successColor
                                                          : theme.failedColor);
                                                } catch (e) {
                                                  UIService.showSnackbar(
                                                      message:
                                                          Tr.t('updateFailed'),
                                                      backgroundColor:
                                                          theme.failedColor);
                                                }

                                                setState(() {
                                                  isUpdatingName = false;
                                                  isUpdatingPhone = false;
                                                  isUpdatingAddress = false;
                                                });
                                              },
                                              child: Text(Tr.t('save'),
                                                  style: const TextStyle(
                                                      color: Colors.white)))),
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        AnalyticsService.logEvent(
                                            'logout_initiated');
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                const PromptLogoutDialog());
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: theme.primaryColor,
                                          padding: EdgeInsets.zero),
                                      child: Text(Tr.t('logout'),
                                          style: const TextStyle(
                                              color: Colors.white))),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: OutlinedButton.icon(
                                      onPressed: () async {
                                        AnalyticsService.logEvent(
                                            'profile_delete_prompt');
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) =>
                                                const PromptDeleteProfileDialog());
                                      },
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          padding: EdgeInsets.zero),
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      label: Text(Tr.t('deleteAccount'))),
                                )
                              ]))))
            ])))));
  }
}
