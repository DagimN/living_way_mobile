import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/themes/light_theme.dart';
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
    final authController = Provider.of<AuthController>(context);

    return AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account?'),
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
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'))
              ]
            : [
                const Center(
                    child: CircularProgressIndicator(
                        color: lightPrimaryColor, strokeWidth: 2))
              ]);
  }
}
