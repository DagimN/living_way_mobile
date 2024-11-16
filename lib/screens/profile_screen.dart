import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/models/profile.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double imageSize = 128.0;
    final profileController = Provider.of<ProfileController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final settingsNavigation =
        Provider.of<LayoutController>(context).settingsNavigation;
    final profile = profileController.userProfile ??
        Profile(id: 'temp-id', firstName: "John", lastName: "Doe");
    final imageProvider = profile.profileImageUrl != null
        ? CachedNetworkImageProvider(profile.profileImageUrl!)
        : null;

    return SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
                height: orientation == Orientation.portrait
                    ? screenHeight * .8
                    : screenWidth * .6,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_none_rounded,
                              color: lightPrimaryColor))),
                  Container(
                      height: imageSize,
                      width: imageSize,
                      margin: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: lightPrimaryColor.withOpacity(.2),
                                offset: const Offset(0, 7),
                                blurRadius: 21,
                                spreadRadius: 1)
                          ],
                          image: DecorationImage(
                              image: profile.profileImageUrl != null
                                  ? imageProvider!
                                  : Image.asset(AppImages.profilePlaceholder)
                                      .image))),
                  Text('${profile.firstName} ${profile.lastName}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 30),
                  Expanded(
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: settingsNavigation.length,
                          itemBuilder: (context, index) {
                            final navigationItem = settingsNavigation[index];
                            return ListTile(
                                onTap: () => Navigator.pushNamed(
                                    context, navigationItem['route'] ?? ''),
                                title: Text(navigationItem['name'] ?? ''),
                                trailing: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14));
                          }))
                ]))));
  }
}
