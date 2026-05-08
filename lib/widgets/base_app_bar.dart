import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class BaseAppBar extends StatelessWidget {
  final Widget? title;
  final List<Widget> actions;
  const BaseAppBar({super.key, this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final themeController = Provider.of<ThemeController>(context);

    return Container(
        margin: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          title ?? const SizedBox(),
          Row(children: [
            ...actions,
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none_rounded,
                    color: AppTheme(themeController.brightness).iconColor)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/profile");
                },
                icon: profileController.userProfile?.profileImageUrl != null
                    ? CircleAvatar(
                        backgroundColor: AppTheme(themeController.brightness)
                            .primaryColor
                            .withAlpha(76),
                        backgroundImage: CachedNetworkImageProvider(
                            profileController.userProfile?.profileImageUrl ??
                                ""))
                    : Image.asset(AppImages.profilePlaceholder, height: 24))
          ])
        ]));
  }
}
