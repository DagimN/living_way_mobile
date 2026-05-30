import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

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
    final themeController = Provider.of<ThemeController>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
        height: screenHeight * .7, child: signupStatusWidget(themeController));
  }

  Widget signupStatusWidget(ThemeController themeController) {
    if (isSigningUp) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.all(16),
            child: CircularProgressIndicator(
                color: AppTheme(themeController.brightness).primaryColor)),
        Text(Tr.t('signup.step5Loading'))
      ]);
    }

    if (isSignupSuccessful && !isSigningUp) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.check_circle,
            color: AppTheme(themeController.brightness).primaryColor,
            size: 128),
        Text(Tr.t('signup.step5Success'))
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
                    Tr.t("signup.step5Error"),
                textAlign: TextAlign.center)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                widget.onReset();
              },
              child: const Icon(Icons.arrow_back)),
          const SizedBox(width: 25),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppTheme(themeController.brightness).primaryColor),
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
