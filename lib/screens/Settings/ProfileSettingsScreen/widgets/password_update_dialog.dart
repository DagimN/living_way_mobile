import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class PasswordUpdateDialog extends StatefulWidget {
  const PasswordUpdateDialog({super.key});

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
        title: Text(Tr.t('profile.changePassword')),
        content: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              hintText:
                                  Tr.t('profile.oldPasswordPlaceholder')))),
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
                              hintText:
                                  Tr.t('profile.newPasswordPlaceholder')))),
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
                              return Tr.t('auth.passwordMismatchError');
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
                              hintText:
                                  Tr.t('auth.confirmPasswordPlaceholder'))))
                ]))),
        actions: !isUpdating
            ? [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Tr.t('common.cancel'))),
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
                            'newPassword', hash(newPasswordController.text))
                      ]);

                      formData.fields.add(
                          MapEntry('oldPassword', oldPasswordController.text));

                      final isSuccess =
                          await profileController.editProfile(formData);

                      setState(() {
                        isUpdating = false;
                      });

                      if (isSuccess) {
                        UIService.showSnackbar(
                            message: Tr.t('profile.updateSuccess'),
                            backgroundColor:
                                AppTheme(themeController.brightness)
                                    .successColor);
                        UIService.pop();
                      } else {
                        UIService.showSnackbar(
                            message: Tr.t('profile.passwordIncorrect'),
                            backgroundColor:
                                AppTheme(themeController.brightness)
                                    .failedColor);
                      }
                    },
                    child: Text(Tr.t('common.update'),
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
