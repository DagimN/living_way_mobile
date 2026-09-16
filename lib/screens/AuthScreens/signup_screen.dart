import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'Forms/email_form.dart';
import 'Forms/name_form.dart';
import 'Forms/password_form.dart';
import 'Forms/signup_complete.dart';
import 'Forms/terms_and_policies_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  double signupFlowIndex = 0;
  int maxSignUpFlow = 4;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    Orientation orientation = MediaQuery.orientationOf(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return PopScope(
        onPopInvokedWithResult: (isPopped, _) {
          if (signupFlowIndex > 0 && signupFlowIndex < maxSignUpFlow) {
            setState(() {
              signupFlowIndex -= 1;
            });
          }
        },
        child: Scaffold(
            appBar: signupFlowIndex != maxSignUpFlow
                ? AppBar(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    title: Text(Tr.t('signupTitle'),
                        style: const TextStyle(fontSize: 24)))
                : AppBar(
                    backgroundColor: theme.backgroundColor,
                    foregroundColor: theme.primaryColor,
                  ),
            backgroundColor: theme.backgroundColor,
            body: SingleChildScrollView(
                child: Container(
                    height: orientation == Orientation.portrait
                        ? screenHeight * .83
                        : screenWidth * .4,
                    margin: const EdgeInsets.all(16),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      currentForm(() => setState(() {
                            signupFlowIndex += 1;
                          })),
                      const Spacer(),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                              color: theme.primaryColor,
                              backgroundColor: theme.primaryColor.withAlpha(51),
                              value: signupFlowIndex / maxSignUpFlow,
                              borderRadius: BorderRadius.circular(20)))
                    ])))));
  }

  Widget currentForm(Function() onProgress) {
    final authController = Provider.of<AuthController>(context);

    switch (signupFlowIndex) {
      case 0:
        return NameForm(onProgress: onProgress, authController: authController);
      case 1: // Get Email
        return EmailForm(
            onProgress: onProgress, authController: authController);
      case 2: // Set Password
        return PasswordForm(onProgress: onProgress);
      case 3: // Privacy Policy and terms
        return TermsAndPoliciesForm(onProgress: onProgress);
      case 4: // Signup complete
        return SignupComplete(
            onReset: () {
              setState(() {
                signupFlowIndex = 0;
              });
            },
            authController: authController);
      default:
        return const SizedBox();
    }
  }
}
