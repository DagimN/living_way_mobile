import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class PasswordForm extends StatefulWidget {
  final Function() onProgress;
  const PasswordForm({super.key, required this.onProgress});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final themeController = Provider.of<ThemeController>(context);

    return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Tr.t("signup.step3Title"),
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
          Text(Tr.t("signup.step3Subtitle"),
              style: const TextStyle(fontSize: 14)),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: TextFormField(
                  keyboardType:
                      isPasswordVisible ? TextInputType.visiblePassword : null,
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value == null) return Tr.t("auth.emptyFieldError");

                    if (value.trim().isEmpty) {
                      return Tr.t("auth.emptyFieldError");
                    }

                    if (!RegExp(r"^(?=.*[a-zA-Z])(?=.*\d).*$")
                        .hasMatch(value)) {
                      return Tr.t("auth.passwordRequirementsAlpha");
                    }

                    if (!RegExp(r"^.{8,}$").hasMatch(value)) {
                      return Tr.t("auth.invalidPasswordError");
                    }

                    if (!RegExp(
                            r"^(?=.*[!@#$%^&*()_+\-=\[\]{};':\\|,.<>\/?]).*$")
                        .hasMatch(value)) {
                      return Tr.t("auth.passwordRequirementsSymbol");
                    }

                    return null;
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: Tr.t("auth.password"),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(!isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off))))),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
              child: TextFormField(
                  keyboardType: isConfirmPasswordVisible
                      ? TextInputType.visiblePassword
                      : null,
                  obscureText: !isConfirmPasswordVisible,
                  validator: (value) {
                    if (value == null) return Tr.t("auth.emptyFieldError");

                    if (value.trim().isEmpty) {
                      return Tr.t("auth.emptyFieldError");
                    }

                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      return Tr.t("auth.passwordMismatchError");
                    }

                    return null;
                  },
                  controller: confirmPasswordController,
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
                      hintText: Tr.t("auth.confirmPassword")))),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme(themeController.brightness).primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;

                    if (!isValid) return;

                    authController.signupProgress.password =
                        passwordController.text;
                    AnalyticsService.logEvent('signup_step_completed',
                        parameters: {'step': 'password'});
                    widget.onProgress();
                  },
                  child: Text(Tr.t('common.continue'))))
        ]));
  }
}
