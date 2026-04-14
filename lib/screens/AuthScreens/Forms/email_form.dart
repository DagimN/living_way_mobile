import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
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

    return Form(
        key: formKey,
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Nice name",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
          const Text(
              "Please provide your email address to ensure your account security.",
              style: TextStyle(fontSize: 14)),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null) return "Empty Field";

                    if (value.trim().isEmpty) return "Empty Field";

                    if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(?:\.[a-zA-Z]+)*$")
                        .hasMatch(value)) {
                      return "Invalid Email";
                    }

                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"))),
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

                    widget.authController.signupProgress.email =
                        emailController.text;

                    widget.onProgress();
                  },
                  child: const Text('Continue')))
        ])));
  }
}
