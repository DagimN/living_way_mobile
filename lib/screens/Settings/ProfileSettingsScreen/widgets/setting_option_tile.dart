import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

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
    return InkWell(
        onTap: onTap,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title),
            !isUpdating
                ? trailing
                : Container(
                    height: 14,
                    width: 14,
                    margin: const EdgeInsets.all(16),
                    child: const CircularProgressIndicator(
                        color: lightPrimaryColor, strokeWidth: 2))
          ]),
          if (!isLast) const Divider(),
          const SizedBox(height: 16)
        ]));
  }
}
