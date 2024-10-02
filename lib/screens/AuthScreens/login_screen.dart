import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:living_way/services/logging_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                child: const Text('Google'),
                onPressed: () async {
                  final account =
                      await GoogleSignIn(scopes: <String>['email', 'profile'])
                          .signIn();

                  logger.i(account);
                })));
  }
}
