import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class PromptLogoutDialog extends StatefulWidget {
  const PromptLogoutDialog({super.key});

  @override
  State<PromptLogoutDialog> createState() => _PromptLogoutDialogState();
}

class _PromptLogoutDialogState extends State<PromptLogoutDialog> {
  bool isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);
    final authController = Provider.of<AuthController>(context);

    return AlertDialog(
        backgroundColor: theme.backgroundColor,
        title: Text(
          Tr.t('common.logout'),
          style: TextStyle(color: theme.accentColor),
        ),
        content: Text(
          Tr.t('profile.logoutMessage'),
          style: TextStyle(color: theme.accentColor),
        ),
        actions: !isLoggingOut
            ? [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isLoggingOut = true;
                      });
                      profileController.clearValues();
                      (authController.isLoggedInViaGoogle
                              ? authController.logoutViaGoogle()
                              : authController.logoutViaManual())
                          .then((value) {
                        setState(() {
                          isLoggingOut = false;
                        });
                        UIService.pushNamedAndRemoveUntil(
                            '/home', (route) => false);
                      });
                    },
                    child: Text(Tr.t('common.logout'),
                        style: const TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      Tr.t('common.cancel'),
                      style: TextStyle(color: theme.accentColor),
                    ))
              ]
            : [
                Center(
                    child: CircularProgressIndicator(
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        strokeWidth: 2))
              ]);
  }
}
