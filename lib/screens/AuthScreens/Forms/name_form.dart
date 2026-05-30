import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class NameForm extends StatefulWidget {
  final AuthController authController;
  final Function() onProgress;
  const NameForm(
      {super.key, required this.onProgress, required this.authController});

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final formKey = GlobalKey<FormState>();
  late final firstNameController = TextEditingController(
      text: widget.authController.signupProgress.firstName);
  late final lastNameController = TextEditingController(
      text: widget.authController.signupProgress.lastName);

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Tr.t("signup.step1Title"),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
          Text(Tr.t("signup.step1Subtitle"),
              style: const TextStyle(fontSize: 14)),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: TextFormField(
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null) return Tr.t("auth.emptyFieldError");

                    if (value.trim().isEmpty) return Tr.t("auth.emptyFieldError");

                    return null;
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintText: Tr.t("signup.firstNamePlaceholder")))),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
              child: TextFormField(
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null) return Tr.t("auth.emptyFieldError");

                    if (value.trim().isEmpty) return Tr.t("auth.emptyFieldError");

                    return null;
                  },
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(), hintText: Tr.t("signup.lastNamePlaceholder")))),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppTheme(themeController.brightness).primaryColor,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    final isValid = formKey.currentState?.validate() ?? false;

                    if (!isValid) return;

                    widget.authController.signupProgress.firstName =
                        firstNameController.text;
                    widget.authController.signupProgress.lastName =
                        lastNameController.text;

                    widget.onProgress();
                  },
                  child: Text(Tr.t('common.continue'))))
        ]));
  }
}
