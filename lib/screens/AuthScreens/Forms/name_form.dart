import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class NameForm extends StatefulWidget {
  final Function() onProgress;
  const NameForm({super.key, required this.onProgress});

  @override
  State<NameForm> createState() => _NameFormState();
}

class _NameFormState extends State<NameForm> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Form(
        key: formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Hi there!!",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
          const Text("Let's get to know you. What's your name?",
              style: TextStyle(fontSize: 14)),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: TextFormField(
                  controller: firstNameController,
                  validator: (value) {
                    if (value == null) return "Empty Field";

                    if (value.trim().isEmpty) return "Empty Field";

                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "First Name"))),
          Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
              child: TextFormField(
                  controller: lastNameController,
                  validator: (value) {
                    if (value == null) return "Empty Field";

                    if (value.trim().isEmpty) return "Empty Field";

                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Last Name"))),
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
        ]));
  }
}
