import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:functional_status_codes/functional_status_codes.dart';
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

  Future<void> onSignup() async {
    final response = await widget.authController.register();
    final isSuccess = response.statusCode.isSuccess;

    setState(() {
      this.response = response;
      isSigningUp = false;
      isSignupSuccessful = isSuccess;
    });

    if (isSuccess) {
      Future.delayed(const Duration(seconds: 3),
          () => UIService.pushNamedAndRemoveUntil('/home', (route) => false));
      AnalyticsService.logEvent('signup_completed',
          parameters: {'status': 'success'});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    double screenHeight = MediaQuery.sizeOf(context).height;

    return SizedBox(
        height: screenHeight * .7, child: signupStatusWidget(theme));
  }

  Widget signupStatusWidget(AppTheme theme) {
    if (isSigningUp) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.all(16),
            child: CircularProgressIndicator(color: theme.primaryColor)),
        Text(Tr.t('step5Loading'), style: TextStyle(color: theme.accentColor))
      ]);
    }

    if (isSignupSuccessful && !isSigningUp) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.check_circle, color: theme.primaryColor, size: 128),
        Text(Tr.t('step5Success'), style: TextStyle(color: theme.accentColor))
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
                    Tr.t("step5Error"),
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.accentColor))),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () async {
                widget.onReset();
                AnalyticsService.logEvent('signup_retry');
              },
              child: const Icon(Icons.arrow_back)),
          const SizedBox(width: 25),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: theme.primaryColor),
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
