import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class PromptDeleteProfileDialog extends StatefulWidget {
  const PromptDeleteProfileDialog({super.key});

  @override
  State<PromptDeleteProfileDialog> createState() =>
      _PromptDeleteProfileDialogState();
}

class _PromptDeleteProfileDialogState extends State<PromptDeleteProfileDialog> {
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final theme = Provider.of<ThemeController>(context).theme;

    final authController = Provider.of<AuthController>(context);

    return AlertDialog(
        title: Text(
          Tr.t('deleteAccount'),
          style: TextStyle(color: theme.accentColor),
        ),
        content: Text(
          Tr.t('deleteAccountMessage'),
          style: TextStyle(color: theme.accentColor),
        ),
        backgroundColor: theme.backgroundColor,
        actions: !isDeleting
            ? [
                TextButton(
                    onPressed: () async {
                      setState(() {
                        isDeleting = true;
                      });
                      await profileController.deleteProfile();
                      (authController.isLoggedInViaGoogle
                              ? authController.logoutViaGoogle()
                              : authController.logoutViaManual())
                          .then((value) {
                        setState(() {
                          isDeleting = false;
                        });
                        UIService.pushNamedAndRemoveUntil(
                            '/home', (route) => false);
                      });
                    },
                    child: Text(Tr.t('delete'),
                        style: const TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      Tr.t('cancel'),
                      style: TextStyle(color: theme.accentColor),
                    ))
              ]
            : [
                Center(
                    child: CircularProgressIndicator(
                        color: theme.primaryColor, strokeWidth: 2))
              ]);
  }
}
