import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/themes/light_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool isLoggingInViaGoogle = false;
  bool isLoggingInViaManual = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const radius = Radius.circular(10);
    bool isPerformingAction = isLoggingInViaGoogle || isLoggingInViaManual;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: screenHeight * .45,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: radius, bottomRight: radius),
                  image: DecorationImage(
                      image: Image.asset(AppImages.loginBackground).image,
                      fit: BoxFit.cover))),
          Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: const TextField(
                            decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "peterrock@gmail.com",
                                labelText: 'Email'))),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: TextField(
                            obscureText: obscurePassword,
                            decoration: InputDecoration(
                                suffix: IconButton(
                                    icon: Icon(obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });
                                    }),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "*****",
                                labelText: 'Password'))),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: !isPerformingAction ? () {} : null,
                            child: const Text('Forgot Password',
                                style: TextStyle(
                                    decoration: TextDecoration.underline)))),
                    !isLoggingInViaManual
                        ? SizedBox(
                            width: screenWidth * .7,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: lightPrimaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: !isPerformingAction
                                    ? () async {
                                        setState(() {
                                          isLoggingInViaManual = true;
                                        });
                                        //TODO: Perform login
                                        await Future.delayed(
                                            const Duration(seconds: 10));

                                        setState(() {
                                          isLoggingInViaManual = false;
                                        });
                                        Navigator.pushNamedAndRemoveUntil(
                                            context, '/home', (route) => false);
                                      }
                                    : null,
                                child: const Text('Login')))
                        : const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                                color: lightPrimaryColor, strokeWidth: 2)),
                    Container(
                        margin: const EdgeInsets.all(16),
                        child: const Divider()),
                    IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 3,
                            shadowColor: Colors.black),
                        icon: isLoggingInViaGoogle
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                    color: lightPrimaryColor, strokeWidth: 2))
                            : Image.asset(AppIcons.google,
                                height: 25, width: 25),
                        onPressed: !isPerformingAction
                            ? () async {
                                setState(() {
                                  isLoggingInViaGoogle = true;
                                });
                                GoogleSignIn(
                                        scopes: <String>['email', 'profile'])
                                    .signIn()
                                    .then((account) {
                                  //TODO: Perform login
                                  if (account != null) {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/home', (route) => false);
                                  }

                                  if (mounted) {
                                    setState(() {
                                      isLoggingInViaGoogle = false;
                                    });
                                  }
                                });
                              }
                            : null),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              const SizedBox(width: 10),
                              InkWell(
                                  onTap: !isPerformingAction
                                      ? () {
                                          //TODO: Perform sign up
                                        }
                                      : null,
                                  child: const Text('Sign Up',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: lightPrimaryColor)))
                            ]))
                  ]))
        ])));
  }
}
