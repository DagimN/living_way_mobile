import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class EmailForm extends StatelessWidget {
  final Function() onProgress;
  const EmailForm({super.key, required this.onProgress});

  @override
  Widget build(BuildContext context) {
    return Form(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text("Nice name",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
                const Text(
            "Please provide your email address to ensure your account security.",
            style: TextStyle(fontSize: 14)),
                Container(
            margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
            child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Email"))),
                Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: lightPrimaryColor,
                    foregroundColor: Colors.white),
                onPressed: onProgress,
                child: const Text('Continue')))
              ]),
        ));
  }
}
