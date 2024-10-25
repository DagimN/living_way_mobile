import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class NameForm extends StatelessWidget {
  final Function() onProgress;
  const NameForm({super.key, required this.onProgress});

  @override
  Widget build(BuildContext context) {
    //TODO: Input validation
    return Form(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text("Hi there!!",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)),
      const Text("Let's get to know you. What's your name?",
          style: TextStyle(fontSize: 14)),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 24, 0, 8),
          child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "First Name"))),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 24),
          child: TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Last Name"))),
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
