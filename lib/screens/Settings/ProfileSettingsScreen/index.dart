import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/TopicScreen/widgets/thread.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'widgets/name_update_dialog.dart';
import 'widgets/password_update_dialog.dart';
import 'widgets/prompt_delete_profile_dialog.dart';
import 'widgets/setting_option_tile.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  bool isUpdatingAnonymous = false;
  bool isUpdatingProfileImage = false;

  @override
  Widget build(BuildContext context) {
    const double imageSize = 128.0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    final themeController = Provider.of<ThemeController>(context);
    final authController = Provider.of<AuthController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final profile = profileController.userProfile ??
        Profile(id: 'temp-id', firstName: "John", lastName: "Doe");
    final imageProvider = profile.profileImageUrl != null
        ? CachedNetworkImageProvider(profile.profileImageUrl!)
        : null;

    //TODO: Define model
    final posts = profileController.posts;

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
                          Text('Profile',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: AppTheme(themeController.brightness)
                                      .primaryColor,
                                  fontWeight: FontWeight.w300))
                        ]),
                        Row(children: [
                          IconButton(
                              onPressed: () {
                                (authController.isLoggedInViaGoogle
                                        ? authController.logoutViaGoogle()
                                        : authController.logoutViaManual())
                                    .then((value) =>
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (route) => false));
                              },
                              icon: Icon(Icons.logout,
                                  color: AppTheme(themeController.brightness)
                                      .primaryColor)),
                          IconButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) =>
                                        const PromptDeleteProfileDialog());
                              },
                              icon: const Icon(Icons.delete, color: Colors.red))
                        ])
                      ])),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  height: orientation == Orientation.portrait
                      ? screenHeight * .85
                      : screenWidth * .32,
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                              color: AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                                  .withAlpha(51),
                                              offset: const Offset(0, 7),
                                              blurRadius: 21,
                                              spreadRadius: 1)
                                        ],
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                profile.profileImageUrl != null
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
                                              color: AppTheme(themeController
                                                      .brightness)
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
                                            setState(() {
                                              isUpdatingProfileImage = true;
                                            });

                                            final images = await ImageService
                                                .openGallery();

                                            if (images.isNotEmpty) {
                                              String fileName = images
                                                  .first.path
                                                  .split('/')
                                                  .last;
                                              FormData formData = FormData();
                                              formData.fields.add(
                                                  MapEntry('id', profile.id));
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
                                                  message: 'No image selected');
                                            }

                                            setState(() {
                                              isUpdatingProfileImage = false;
                                            });
                                          },
                                          icon: Icon(Icons.image,
                                              color: AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor,
                                              size: 20))))
                            ])),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${profile.firstName} ${profile.lastName}',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return NameUpdateDialog(
                                              firstName: profile.firstName,
                                              lastName: profile.lastName);
                                        });
                                  },
                                  icon: Icon(Icons.edit,
                                      color:
                                          AppTheme(themeController.brightness)
                                              .primaryColor))
                            ]),
                        SettingOptionTile(
                            title: 'Anonymous',
                            isUpdating: isUpdatingAnonymous,
                            trailing: Checkbox(
                                checkColor: Colors.white,
                                activeColor:
                                    AppTheme(themeController.brightness)
                                        .primaryColor,
                                value: profile.isAnonymous,
                                onChanged: (value) async {
                                  setState(() {
                                    isUpdatingAnonymous = true;
                                  });

                                  final formData = FormData();
                                  formData.fields.addAll([
                                    MapEntry('id', profile.id),
                                    MapEntry('isAnonymous',
                                        (value ?? false) ? 'true' : 'false')
                                  ]);

                                  await profileController.editProfile(formData);

                                  setState(() {
                                    isUpdatingAnonymous = false;
                                  });
                                })),
                        SettingOptionTile(
                            title: 'Change Password',
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => PasswordUpdateDialog(
                                      passwordExists: profile.passwordExists));
                            },
                            trailing: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Color(0xFF413F2B))),
                            isLast: true),
                        const SizedBox(height: 32),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Your Threads",
                                  style: TextStyle(
                                      color:
                                          AppTheme(themeController.brightness)
                                              .primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              posts.length > 3
                                  ? InkWell(
                                      onTap: () {},
                                      child: Text('More',
                                          style: TextStyle(
                                              color: AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor,
                                              decoration:
                                                  TextDecoration.underline)))
                                  : const SizedBox()
                            ]),
                        posts.isNotEmpty
                            ? ListView.builder(
                                itemCount: min(posts.length, 3),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Thread(
                                      topic: Topic(
                                          id: '',
                                          title: 'Book of Daniel',
                                          backgroundImageUrl:
                                              "https://cdn.pixabay.com/photo/2023/03/30/01/40/daniel-7886652_1280.jpg",
                                          timestamp: DateTime.now()),
                                      isLast: true,
                                      data: ThreadData(
                                          timestamp: DateTime.now(),
                                          threadId: const Uuid().v4(),
                                          commenter: const Uuid().v4(),
                                          comment: 'Comment 1',
                                          likers: []));
                                })
                            : Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 24),
                                child: Column(children: [
                                  Image.asset(AppImages.emptyContent),
                                  const Text(
                                      'You have not posted anything yet.',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300))
                                ]))
                      ])))
            ])))));
  }
}
