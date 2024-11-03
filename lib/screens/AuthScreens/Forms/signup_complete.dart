import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/themes/light_theme.dart';

class SignupComplete extends StatefulWidget {
  final AuthController authController;
  final Function() onReset;
  const SignupComplete(
      {super.key, required this.authController, required this.onReset});

  @override
  State<SignupComplete> createState() => _SignupCompleteState();
}

class _SignupCompleteState extends State<SignupComplete> {
  bool isSignupSuccessful = false;
  bool isSigningUp = true;
  Response? response;

  @override
  void initState() {
    super.initState();
    onSignup();
  }

  void onSignup() {
    widget.authController.performSignup().then((response) {
      final isSuccess = response.statusCode == 201;

      setState(() {
        this.response = response;
        isSigningUp = false;
        isSignupSuccessful = isSuccess;
      });

      if (isSuccess) {
        Future.delayed(
            const Duration(seconds: 3),
            () => Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(height: screenHeight * .7, child: signupStatusWidget());
  }

  Widget signupStatusWidget() {
    if (isSigningUp) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.all(16),
            child: const CircularProgressIndicator(color: lightPrimaryColor)),
        const Text('Finalizing Profile')
      ]);
    }

    if (isSignupSuccessful && !isSigningUp) {
      return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: lightPrimaryColor, size: 128),
            Text('Signup Completed')
          ]);
    }

    if (!isSignupSuccessful && !isSigningUp) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.warning, color: Colors.red, size: 128),
        Container(
            margin: const EdgeInsets.all(16),
            child: Text(
                response?.data['message'] ??
                    response?.statusMessage ??
                    "Could not complete sign up process",
                textAlign: TextAlign.center)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                widget.onReset();
              },
              child: const Icon(Icons.arrow_back)),
          const SizedBox(width: 25),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: lightPrimaryColor),
              onPressed: () {
                setState(() {
                  isSigningUp = true;
                });

                onSignup();
              },
              child: const Icon(Icons.refresh, color: Colors.white))
        ])
      ]);
    }

    return const SizedBox();
  }
}
