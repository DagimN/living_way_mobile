import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/models/profile.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/TopicScreen/widgets/thread.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double imageSize = 128.0;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    const profilePosts = ['', '', '', '', ''];

    final authController = Provider.of<AuthController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final profile = profileController.userProfile ??
        Profile(firstName: "John", lastName: "Doe");
    final imageProvider = profile.imageUrl != null
        ? CachedNetworkImageProvider(profile.imageUrl!)
        : null;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: SafeArea(
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
                              icon: const Icon(Icons.arrow_back,
                                  color: lightPrimaryColor)),
                          const Text('Profile',
                              style: TextStyle(
                                  fontSize: 32,
                                  color: lightPrimaryColor,
                                  fontWeight: FontWeight.w300))
                        ]),
                        Row(children: [
                          IconButton(
                              onPressed: () async {
                                authController.isLoggedInViaGoogle
                                    ? await authController.logoutViaGoogle()
                                    : () {
                                      //TODO: Perform manual logout
                                    };

                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                              icon: const Icon(Icons.logout,
                                  color: lightPrimaryColor)),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
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
                              Container(
                                  height: imageSize,
                                  width: imageSize,
                                  margin: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: lightPrimaryColor
                                                .withOpacity(.2),
                                            offset: const Offset(0, 7),
                                            blurRadius: 21,
                                            spreadRadius: 1)
                                      ],
                                      image: DecorationImage(
                                          image: profile.imageUrl != null
                                              ? imageProvider!
                                              : Image.asset(AppImages
                                                      .profilePlaceholder)
                                                  .image))),
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
                                          onPressed: () {},
                                          icon: const Icon(Icons.image,
                                              color: lightPrimaryColor,
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
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit,
                                      color: lightPrimaryColor))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Anonymous'),
                              Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: lightPrimaryColor,
                                  value: profileController.isAnonymous,
                                  onChanged: (value) {
                                    profileController.setAnonymousProfile =
                                        value ?? false;
                                  })
                            ]),
                        const SizedBox(height: 32),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Your Posts",
                                  style: TextStyle(
                                      color: lightPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              profilePosts.length > 3
                                  ? InkWell(
                                      onTap: () {},
                                      child: const Text('More',
                                          style: TextStyle(
                                              color: lightPrimaryColor,
                                              decoration:
                                                  TextDecoration.underline)))
                                  : const SizedBox()
                            ]),
                        const Divider(),
                        ListView.builder(
                            itemCount: min(profilePosts.length, 3),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Thread(
                                  topic: Topic(
                                      title: 'Book of Daniel',
                                      viewCount: 18000,
                                      likeCount: 500,
                                      isFavorite: true,
                                      backgroundImageUrl:
                                          "https://cdn.pixabay.com/photo/2023/03/30/01/40/daniel-7886652_1280.jpg"),
                                  isLast: true,
                                  data: ThreadData(
                                      threadId: const Uuid().v4(),
                                      commenter: const Uuid().v4(),
                                      comment: 'Comment 1',
                                      likes: 50));
                            })
                      ])))
            ]))));
  }
}
