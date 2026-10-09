import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:provider/provider.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: theme.primaryColor.withAlpha(180),
          ),
        ),
      ],
    );
  }
}
