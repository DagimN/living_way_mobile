import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class EmailForm extends StatefulWidget {
  final Function() onProgress;
  const EmailForm({super.key, required this.onProgress});

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                        .hasMatch(value)) return "Invalid Email";

                    return null;
                  },
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Email"))),
          Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: lightPrimaryColor,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    final isValid = formKey.currentState?.validate() ?? false;

                    if (!isValid) return;

                    widget.onProgress();
                  },
                  child: const Text('Continue')))
        ])));
  }
}
