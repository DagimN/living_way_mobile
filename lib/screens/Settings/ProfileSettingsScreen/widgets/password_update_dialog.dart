import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:living_way/core/utils/security_functions.dart';
import 'package:provider/provider.dart';

class PasswordUpdateDialog extends StatefulWidget {
  final bool passwordExists;
  const PasswordUpdateDialog({super.key, required this.passwordExists});

  @override
  PasswordUpdateDialogState createState() => PasswordUpdateDialogState();
}

class PasswordUpdateDialogState extends State<PasswordUpdateDialog> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isUpdating = false;
  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    final themeController = Provider.of<ThemeController>(context);

    return AlertDialog(
        title: const Text('Change password'),
        content: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  if (widget.passwordExists)
                    Container(
                        margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                        child: TextFormField(
                            keyboardType: isOldPasswordVisible
                                ? TextInputType.visiblePassword
                                : null,
                            obscureText: !isOldPasswordVisible,
                            controller: oldPasswordController,
                            validator: (value) {
                              if (value == null) return "Empty Field";

                              if (value.trim().isEmpty) return "Empty Field";

                              return null;
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isOldPasswordVisible =
                                            !isOldPasswordVisible;
                                      });
                                    },
                                    icon: Icon(!isOldPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                                border: const OutlineInputBorder(),
                                hintText: "Old Password"))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: TextFormField(
                          keyboardType: isNewPasswordVisible
                              ? TextInputType.visiblePassword
                              : null,
                          obscureText: !isNewPasswordVisible,
                          controller: newPasswordController,
                          validator: (value) {
                            if (value == null) return "Empty Field";

                            if (value.trim().isEmpty) return "Empty Field";

                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isNewPasswordVisible =
                                          !isNewPasswordVisible;
                                    });
                                  },
                                  icon: Icon(!isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              border: const OutlineInputBorder(),
                              hintText: "New Password"))),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                      child: TextFormField(
                          keyboardType: isConfirmPasswordVisible
                              ? TextInputType.visiblePassword
                              : null,
                          obscureText: !isConfirmPasswordVisible,
                          controller: confirmPasswordController,
                          validator: (value) {
                            if (value == null) return "Empty Field";

                            if (value.trim().isEmpty) return "Empty Field";

                            if (newPasswordController.text !=
                                confirmPasswordController.text) {
                              return "Passwords does not match";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isConfirmPasswordVisible =
                                          !isConfirmPasswordVisible;
                                    });
                                  },
                                  icon: Icon(!isConfirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              border: const OutlineInputBorder(),
                              hintText: "Confirm Password")))
                ]))),
        actions: !isUpdating
            ? [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.red))),
                TextButton(
                    onPressed: () async {
                      final isValid = formKey.currentState?.validate() ?? false;

                      if (!isValid) return;

                      setState(() {
                        isUpdating = true;
                      });

                      final formData = FormData();
                      formData.fields.addAll([
                        MapEntry('id', profileController.userProfile?.id ?? ""),
                        MapEntry(
                            'newPassword', encrypt(newPasswordController.text))
                      ]);

                      if (widget.passwordExists) {
                        formData.fields.add(MapEntry('oldPassword',
                            encrypt(oldPasswordController.text)));
                      }

                      profileController.editProfile(formData).then((value) {
                        setState(() {
                          isUpdating = false;
                        });
                        //TODO: Warn user if password is incorrect
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Update',
                        style: TextStyle(
                            color: AppTheme(themeController.brightness)
                                .primaryColor)))
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
