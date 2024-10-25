import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class SignupComplete extends StatelessWidget {
  const SignupComplete({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    double screenHeight = MediaQuery.sizeOf(context).height;

    // authController.performSignup().then((isSuccess) {
    //   if (isSuccess) {
    //     Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    //   }
    // });

    return SizedBox(
        height: screenHeight * .7,
        child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: lightPrimaryColor, size: 128),
              Text('Signup Completed')
            ]));
  }
}
