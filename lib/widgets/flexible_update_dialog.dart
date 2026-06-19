import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class FlexibleUpdateDialog extends StatelessWidget {
  final String version;
  final String message;
  final VoidCallback onUpdate;

  const FlexibleUpdateDialog({
    super.key,
    required this.version,
    required this.message,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = Theme.of(context);
    final appTheme = AppTheme(themeController.brightness);
    final primaryColor = appTheme.primaryColor;

    return Dialog(
      backgroundColor: appTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.info_outline_rounded,
                      color: primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  Tr.arg('settings.newUpdate', version),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: appTheme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: appTheme.accentColor,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(Tr.t('common.update')),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: appTheme.accentColor),
                    child: Text(Tr.t('common.notNow')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
