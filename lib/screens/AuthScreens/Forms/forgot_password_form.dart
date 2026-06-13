import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppTheme(themeController.brightness).primaryColor,
          foregroundColor: Colors.white),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(Tr.t("auth.forgotPasswordTitle"),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w500)),
                  Text(Tr.t("auth.forgotPasswordSubtitle"),
                      style: const TextStyle(fontSize: 14)),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null) {
                              return Tr.t("auth.emptyFieldError");
                            }

                            if (value.trim().isEmpty) {
                              return Tr.t("auth.emptyFieldError");
                            }

                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(?:\.[a-zA-Z]+)*$")
                                .hasMatch(value)) {
                              return Tr.t("auth.invalidEmailError");
                            }

                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: Tr.t("auth.email")))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme(themeController.brightness)
                                      .primaryColor,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            final isValid =
                                formKey.currentState?.validate() ?? false;

                            if (!isValid) return;

                            AnalyticsService.logEvent(
                                'user_forgot_password_initiated');
                            final isSent = await Provider.of<AuthController>(
                                    context,
                                    listen: false)
                                .forgotPassword(email: emailController.text);

                            if (isSent) {
                              UIService.showSnackbar(
                                  backgroundColor:
                                      AppTheme(themeController.brightness)
                                          .successColor,
                                  message: Tr.t('auth.forgotPasswordSuccess'));
                            } else {
                              UIService.showSnackbar(
                                  backgroundColor:
                                      AppTheme(themeController.brightness)
                                          .failedColor,
                                  message: Tr.t('auth.forgotPasswordError'));
                            }
                          },
                          child: Text(Tr.t('common.continue'))))
                ]))),
      ),
    );
  }
}
