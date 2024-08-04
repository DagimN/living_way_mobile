import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double imageSize = 128.0;
    final settingsNavigation =
        Provider.of<LayoutController>(context).settingsNavigation;

    return SafeArea(
        child: Column(children: [
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
                  image: Image.asset(AppImages.profilePlaceholder).image))),
      const Text('John Doe',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
      const SizedBox(height: 30),
      Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: settingsNavigation.length,
              itemBuilder: (context, index) {
                final navigationItem = settingsNavigation[index];
                return ListTile(
                    onTap: () => Navigator.pushNamed(
                        context, navigationItem['route'] ?? ''),
                    title: Text(navigationItem['name'] ?? ''),
                    trailing:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14));
              }))
    ]));
  }
}
