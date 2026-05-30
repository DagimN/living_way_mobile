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
    final themeController = Provider.of<ThemeController>(context);
    final authController = Provider.of<AuthController>(context);

    return AlertDialog(
        title: Text(Tr.t('profile.deleteAccount')),
        content: Text(Tr.t('profile.deleteAccountMessage')),
        actions: !isDeleting
            ? [
                TextButton(
                    onPressed: () async {
                      //TODO: Test delete feature
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
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      });
                    },
                    child: Text(Tr.t('common.delete'),
                        style: const TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Tr.t('common.cancel')))
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
