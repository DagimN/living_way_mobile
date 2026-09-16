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
    final theme = AppTheme(themeController.brightness);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
      backgroundColor: theme.backgroundColor,
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(Tr.t("forgotPasswordTitle"),
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: theme.accentColor)),
                  Text(Tr.t("forgotPasswordSubtitle"),
                      style: TextStyle(fontSize: 14, color: theme.accentColor)),
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                      child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null) {
                              return Tr.t("emptyFieldError");
                            }

                            if (value.trim().isEmpty) {
                              return Tr.t("emptyFieldError");
                            }

                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(?:\.[a-zA-Z]+)*$")
                                .hasMatch(value)) {
                              return Tr.t("invalidEmailError");
                            }

                            return null;
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: Tr.t("email")))),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
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
                                  backgroundColor: theme.successColor,
                                  message: Tr.t('forgotPasswordSuccess'));
                            } else {
                              UIService.showSnackbar(
                                  backgroundColor: theme.failedColor,
                                  message: Tr.t('forgotPasswordError'));
                            }
                          },
                          child: Text(Tr.t('continue'))))
                ]))),
      ),
    );
  }
}
