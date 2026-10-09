import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:provider/provider.dart';

class MiniStatusDot extends StatelessWidget {
  final bool isCompleted;
  final bool isLocked;
  final bool itemExists;

  const MiniStatusDot({
    super.key,
    required this.isCompleted,
    required this.isLocked,
    required this.itemExists,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    if (isCompleted) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: theme.successColor,
          shape: BoxShape.circle,
        ),
      );
    }
    if (isLocked) {
      return Icon(
        Icons.lock_rounded,
        size: 7,
        color: theme.inactiveColor.withAlpha(100),
      );
    }
    if (itemExists) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: theme.primaryColor, width: 1),
        ),
      );
    }

    return const SizedBox(height: 6);
  }
}
