import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class SettingOptionTile extends StatelessWidget {
  final String title;
  final Widget trailing;
  final bool isUpdating;
  final Function()? onTap;
  final bool isLast;
  const SettingOptionTile(
      {super.key,
      required this.title,
      required this.trailing,
      this.onTap,
      this.isLast = false,
      this.isUpdating = false});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return InkWell(
        onTap: onTap,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title),
            !isUpdating
                ? trailing
                : SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                        color: theme.primaryColor, strokeWidth: 2))
          ]),
          if (!isLast) const Divider(),
          const SizedBox(height: 16)
        ]));
  }
}
