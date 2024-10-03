import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/services/logging_service.dart';
import 'package:living_way/themes/light_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
              height: screenHeight * .45,
              child: Stack(children: [
                Positioned(
                    bottom: 5,
                    child: Image.asset(AppImages.loginBackground,
                        width: screenWidth,
                        height: screenHeight * .45,
                        fit: BoxFit.cover)),
                Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [
                      0.15,
                      0.5,
                      0.7,
                      0.85,
                      1
                    ],
                            colors: [
                      Colors.transparent,
                      Color(0x3FFFFBDC),
                      Color(0x7EFFFFFF),
                      Color(0xBEF9F9F9),
                      Color(0xFFFEFEFE)
                    ])))
              ])),
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
                            onTap: () {},
                            child: const Text('Forgot Password',
                                style: TextStyle(
                                    decoration: TextDecoration.underline)))),
                    SizedBox(
                        width: screenWidth * .7,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: lightPrimaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: const Text('Login'),
                            onPressed: () async {
                              final account = await GoogleSignIn(
                                      scopes: <String>['email', 'profile'])
                                  .signIn();

                              logger.i(account);
                            })),
                    const SizedBox(height: 36),
                    const Divider(),
                    //TODO: Make google its own theme
                    IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: lightPrimaryColor),
                        icon: const FaIcon(FontAwesomeIcons.google,
                            color: Colors.white),
                        onPressed: () async {
                          final account = await GoogleSignIn(
                              scopes: <String>['email', 'profile']).signIn();

                          logger.i(account);
                        })
                  ]))
        ])));
  }
}
