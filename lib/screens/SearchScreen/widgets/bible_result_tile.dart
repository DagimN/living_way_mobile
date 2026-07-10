import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class BibleResultTile extends StatelessWidget {
  final BibleSearchResult result;
  final VoidCallback? onTap;

  const BibleResultTile({super.key, required this.result, this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        result.title,
        style: TextStyle(color: theme.accentColor, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        result.passage.text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: theme.accentColor.withAlpha(192)),
      ),
    );
  }
}
