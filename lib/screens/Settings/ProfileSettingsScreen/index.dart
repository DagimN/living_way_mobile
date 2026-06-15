import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/AuthScreens/login_screen.dart';
import 'package:provider/provider.dart';

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
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool isUpdatingAnonymous = false;
  bool isUpdatingProfileImage = false;
  bool isUpdatingName = false;

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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double imageSize = 128.0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    final themeController = Provider.of<ThemeController>(context);
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
          appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: AppTheme(themeController.brightness).primaryColor),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          body: const VerifyEmailMessage());
    }

    bool areValuesUpdated() {
      return firstNameController.text != profile.firstName ||
          lastNameController.text != profile.lastName;
    }

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.arrow_back,
                                  color: AppTheme(themeController.brightness)
                                      .primaryColor)),
                          Text(Tr.t('navigation.profile'),
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppTheme(themeController.brightness)
                                      .primaryColor,
                                  fontWeight: FontWeight.w300))
                        ]),
                        const SizedBox.shrink()
                      ])),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: orientation == Orientation.portrait
                      ? screenHeight * .85
                      : screenWidth * .32,
                  child: SingleChildScrollView(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.fromLTRB(0, 52, 0, 16),
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
                                          color: AppTheme(
                                                  themeController.brightness)
                                              .primaryColor
                                              .withAlpha(51),
                                          offset: const Offset(0, 7),
                                          blurRadius: 21,
                                          spreadRadius: 1)
                                    ],
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: profile.profileImageUrl != null
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
                                      color: Colors.black.withAlpha(76)),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                          color: AppTheme(
                                                  themeController.brightness)
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
                                          backgroundColor: Colors.white,
                                          elevation: 5,
                                          shadowColor: Colors.black),
                                      onPressed: () async {
                                        AnalyticsService.logEvent(
                                            'profile_image_update_started');
                                        setState(() {
                                          isUpdatingProfileImage = true;
                                        });

                                        final images =
                                            await ImageService.openGallery();

                                        if (images.isNotEmpty) {
                                          String fileName =
                                              images.first.path.split('/').last;
                                          FormData formData = FormData();
                                          formData.fields
                                              .add(MapEntry('id', profile.id));
                                          formData.files.add(MapEntry(
                                              'image',
                                              await MultipartFile.fromFile(
                                                  images.first.path,
                                                  filename: fileName)));

                                          await profileController
                                              .editProfile(formData);
                                        } else {
                                          UIService.showSnackbar(
                                              backgroundColor: AppTheme(
                                                      themeController
                                                          .brightness)
                                                  .failedColor,
                                              message: Tr.t(
                                                  'profile.noImageSelected'));
                                        }

                                        setState(() {
                                          isUpdatingProfileImage = false;
                                        });
                                      },
                                      icon: Icon(Icons.image,
                                          color: AppTheme(
                                                  themeController.brightness)
                                              .primaryColor,
                                          size: 20))))
                        ])),
                    TextFormField(
                        controller: firstNameController,
                        onChanged: (value) => setState(() {}),
                        enabled: !isUpdatingName,
                        decoration: InputDecoration(
                            labelText: Tr.t('profile.firstName'),
                            border: const OutlineInputBorder()),
                        textInputAction: TextInputAction.next),
                    const SizedBox(height: 12),
                    TextFormField(
                        controller: lastNameController,
                        onChanged: (value) => setState(() {}),
                        enabled: !isUpdatingName,
                        decoration: InputDecoration(
                            labelText: Tr.t('profile.lastName'),
                            border: const OutlineInputBorder()),
                        textInputAction: TextInputAction.done),
                    const SizedBox(height: 12),
                    if (authController.isLoggedInViaManual)
                      SettingOptionTile(
                          title: Tr.t('profile.changePassword'),
                          onTap: () async {
                            AnalyticsService.logEvent(
                                'profile_change_password_opened');
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    const PasswordUpdateDialog());
                          },
                          trailing: const Icon(Icons.arrow_forward_ios_rounded,
                              color: Color(0xFF413F2B)),
                          isLast: true),
                    if (areValuesUpdated())
                      Container(
                          width: 200,
                          margin: const EdgeInsets.all(8),
                          child: isUpdatingName
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color:
                                          AppTheme(themeController.brightness)
                                              .primaryColor))
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor:
                                          AppTheme(themeController.brightness)
                                              .primaryColor),
                                  onPressed: () async {
                                    setState(() {
                                      isUpdatingName = true;
                                    });

                                    FormData formData = FormData();
                                    formData.fields
                                        .add(MapEntry('id', profile.id));
                                    formData.fields.add(MapEntry(
                                        'firstName', firstNameController.text));
                                    formData.fields.add(MapEntry(
                                        'lastName', lastNameController.text));

                                    try {
                                      await profileController
                                          .editProfile(formData);
                                      UIService.showSnackbar(
                                          message:
                                              Tr.t('profile.updateSuccess'),
                                          backgroundColor: AppTheme(
                                                  themeController.brightness)
                                              .successColor);
                                    } catch (e) {
                                      UIService.showSnackbar(
                                          message: Tr.t('profile.updateFailed'),
                                          backgroundColor: AppTheme(
                                                  themeController.brightness)
                                              .failedColor);
                                    }

                                    setState(() {
                                      isUpdatingName = false;
                                    });
                                  },
                                  child: Text(Tr.t('common.save'),
                                      style: const TextStyle(
                                          color: Colors.white)))),
                    Container(
                      width: 200,
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          onPressed: () async {
                            AnalyticsService.logEvent('logout_initiated');
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const PromptLogoutDialog());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme(themeController.brightness)
                                      .primaryColor,
                              padding: EdgeInsets.zero),
                          child: Text(Tr.t('common.logout'),
                              style: const TextStyle(color: Colors.white))),
                    ),
                    Container(
                      width: 200,
                      margin: const EdgeInsets.all(8),
                      child: OutlinedButton.icon(
                          onPressed: () async {
                            AnalyticsService.logEvent('profile_delete_prompt');
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const PromptDeleteProfileDialog());
                          },
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: EdgeInsets.zero),
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: Text(Tr.t('common.deleteAccount'))),
                    )
                  ])))
            ])))));
  }
}
