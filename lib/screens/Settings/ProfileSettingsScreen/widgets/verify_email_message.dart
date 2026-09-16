import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class VerifyEmailMessage extends StatelessWidget {
  const VerifyEmailMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final theme = AppTheme(themeController.brightness);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: theme.topicGradient,
          color: theme.primaryPanelColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: theme.inactiveColor.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: theme.primaryColor.withAlpha(30),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, screenHeight * .25, 16, 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColor.withAlpha(30),
                ),
                child: Icon(
                  Icons.mark_email_unread_rounded,
                  color: theme.primaryColor,
                  size: 72,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Tr.t('verifyEmail'),
                      style: TextStyle(
                        color: theme.subHeadingColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Tr.arg('verifyEmailMessage',
                          profileController.userProfile?.email ?? ""),
                      style: TextStyle(
                        color: theme.iconColor.withAlpha(230),
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            color: theme.pendingColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Tr.t('verificationPending'),
                          style: TextStyle(
                            color: theme.inactiveColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
