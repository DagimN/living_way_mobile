import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class ForcedUpdateDialog extends StatelessWidget {
  final String version;
  final String message;
  final VoidCallback onUpdate;

  const ForcedUpdateDialog({
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
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(38),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.warning_amber_rounded,
                  color: Colors.amber.shade800, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              Tr.t('updateAvailable'),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: appTheme.accentColor,
                  fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              Tr.t('updateRequired'),
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: appTheme.accentColor, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: appTheme.accentColor,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withAlpha(20),
                  ),
                ),
                Icon(Icons.rocket_launch_rounded,
                    size: 48, color: primaryColor),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'v$version',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appTheme.accentColor,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  Tr.t('update'),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, letterSpacing: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
