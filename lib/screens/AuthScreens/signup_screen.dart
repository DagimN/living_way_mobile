import 'package:flutter/material.dart';
import 'package:living_way/screens/AuthScreens/Forms/email_form.dart';
import 'package:living_way/screens/AuthScreens/Forms/name_form.dart';
import 'package:living_way/screens/AuthScreens/Forms/password_form.dart';
import 'package:living_way/screens/AuthScreens/Forms/signup_complete.dart';
import 'package:living_way/screens/AuthScreens/Forms/terms_and_policies_form.dart';
import 'package:living_way/themes/light_theme.dart';

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

    return PopScope(
        canPop: signupFlowIndex == 0,
        onPopInvoked: (isPopped) {
          if (signupFlowIndex > 0 && signupFlowIndex < maxSignUpFlow) {
            setState(() {
              signupFlowIndex -= 1;
            });
          }
        },
        child: Scaffold(
            appBar: signupFlowIndex != maxSignUpFlow
                ? AppBar(
                    backgroundColor: lightPrimaryColor,
                    foregroundColor: Colors.white,
                    title:
                        const Text('Welcome', style: TextStyle(fontSize: 24)))
                : null,
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
                      const Spacer(), //TODO: Add animation
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: LinearProgressIndicator(
                              color: lightPrimaryColor,
                              backgroundColor:
                                  lightPrimaryColor.withOpacity(0.2),
                              value: signupFlowIndex / maxSignUpFlow,
                              borderRadius: BorderRadius.circular(20)))
                    ])))));
  }

  Widget currentForm(Function() onProgress) {
    switch (signupFlowIndex) {
      case 0:
        return NameForm(onProgress: onProgress);
      case 1: // Get Email
        return EmailForm(onProgress: onProgress);
      case 2: // Set Password
        return PasswordForm(onProgress: onProgress);
      case 3: // Privacy Policy and terms
        return TermsAndPoliciesForm(onProgress: onProgress);
      case 4: // Signup complete
        return const SignupComplete();
      default:
        return const SizedBox();
    }
  }
}
