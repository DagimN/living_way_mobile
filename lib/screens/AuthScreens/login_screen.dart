import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoggingInViaGoogle = false;
  bool isLoggingInViaManual = false;

  void performManualLogin(AuthController controller) async {
    AnalyticsService.logEvent('login_attempt',
        parameters: {'method': 'manual'});
    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    setState(() {
      isLoggingInViaManual = true;
    });

    final isSuccessful = await controller.loginViaManual(
        emailController.text, passwordController.text);

    setState(() {
      isLoggingInViaManual = false;
    });

    if (isSuccessful) {
      UIService.pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  void performGoogleLogin(AuthController controller) async {
    AnalyticsService.logEvent('login_attempt',
        parameters: {'method': 'google'});
    setState(() {
      isLoggingInViaGoogle = true;
    });

    final isSuccess = await controller.loginViaGoogle();

    setState(() {
      isLoggingInViaGoogle = false;
    });

    if (isSuccess) {
      UIService.pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final themeController = Provider.of<ThemeController>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    const radius = Radius.circular(10);
    bool isPerformingAction = isLoggingInViaGoogle || isLoggingInViaManual;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0x80000000)),
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(children: [
                  Container(
                      height: screenHeight * .45,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: radius, bottomRight: radius),
                          image: DecorationImage(
                              image:
                                  Image.asset(AppImages.loginBackground).image,
                              fit: BoxFit.cover))),
                  Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null) {
                                        return Tr.t('auth.emptyFieldError');
                                      }

                                      if (value.trim().isEmpty) {
                                        return Tr.t('auth.emptyFieldError');
                                      }

                                      if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(?:\.[a-zA-Z]+)*$")
                                          .hasMatch(value)) {
                                        return Tr.t('auth.invalidEmailError');
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: Tr.t('auth.emailPlaceholder'),
                                        labelText: Tr.t('auth.email')))),
                            Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                    controller: passwordController,
                                    validator: (value) {
                                      if (value == null) {
                                        return Tr.t('auth.emptyFieldError');
                                      }

                                      if (value.trim().isEmpty) {
                                        return Tr.t('auth.emptyFieldError');
                                      }

                                      return null;
                                    },
                                    obscureText: obscurePassword,
                                    decoration: InputDecoration(
                                        suffix: IconButton(
                                            icon: Icon(obscurePassword
                                                ? Icons.visibility
                                                : Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                obscurePassword =
                                                    !obscurePassword;
                                              });
                                            }),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText:
                                            Tr.t('auth.passwordPlaceholder'),
                                        labelText: Tr.t('auth.password')))),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 24),
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                    onTap: !isPerformingAction
                                        ? () {
                                            Navigator.pushNamed(
                                                context, '/forgot-password');
                                          }
                                        : null,
                                    child: Text(Tr.t('auth.forgotPassword'),
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline)))),
                            !isLoggingInViaManual
                                ? SizedBox(
                                    width: screenWidth * .7,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppTheme(themeController
                                                        .brightness)
                                                    .primaryColor,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        onPressed: !isPerformingAction
                                            ? () => performManualLogin(
                                                authController)
                                            : null,
                                        child: Text(Tr.t('auth.login'))))
                                : SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                        color:
                                            AppTheme(themeController.brightness)
                                                .primaryColor,
                                        strokeWidth: 2)),
                            Container(
                                margin: const EdgeInsets.all(16),
                                child: const Divider()),
                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 3,
                                    shadowColor: Colors.black),
                                icon: isLoggingInViaGoogle
                                    ? SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor,
                                            strokeWidth: 2))
                                    : Image.asset(AppIcons.google,
                                        height: 25, width: 25),
                                onPressed: !isPerformingAction
                                    ? () => performGoogleLogin(authController)
                                    : null),
                            Container(
                                margin: const EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(Tr.t('auth.dontHaveAccount')),
                                      const SizedBox(width: 10),
                                      InkWell(
                                          onTap: !isPerformingAction
                                              ? () {
                                                  Navigator.pushNamed(
                                                      context, '/intro');
                                                }
                                              : null,
                                          child: Text(Tr.t('auth.signUp'),
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: AppTheme(
                                                          themeController
                                                              .brightness)
                                                      .primaryColor)))
                                    ]))
                          ]))
                ]))));
  }
}
