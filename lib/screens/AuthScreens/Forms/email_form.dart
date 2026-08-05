import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class EmailForm extends StatefulWidget {
  final AuthController authController;
  final Function() onProgress;
  const EmailForm(
      {super.key, required this.onProgress, required this.authController});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final formKey = GlobalKey<FormState>();
  late final emailController =
      TextEditingController(text: widget.authController.signupProgress.email);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return Form(
        key: formKey,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Tr.t("step2Title"),
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: theme.accentColor)),
          Text(Tr.t("step2Subtitle"),
              style: TextStyle(fontSize: 14, color: theme.accentColor)),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) return Tr.t("emptyFieldError");

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
                      backgroundColor:
                          AppTheme(themeController.brightness).primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate() ?? false;

                    if (!isValid) return;

                    widget.authController.signupProgress.email =
                        emailController.text;
                    widget.onProgress();
                    AnalyticsService.logEvent('signup_step_completed',
                        parameters: {'step': 'email'});
                  },
                  child: Text(Tr.t('continue'))))
        ])));
  }
}
