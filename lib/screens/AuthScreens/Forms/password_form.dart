import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class PasswordForm extends StatelessWidget {
  final Function() onProgress;
  const PasswordForm({super.key, required this.onProgress});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Great",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
      const Text(
          "Keep your personal information safe by creating a strong password for your account.",
          style: TextStyle(fontSize: 14)),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
          child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Password"))),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
          child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Confirm Password"))),
      Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: lightPrimaryColor,
                  foregroundColor: Colors.white),
              onPressed: onProgress,
              child: const Text('Continue')))
    ]));
  }
}
