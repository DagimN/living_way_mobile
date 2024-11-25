import 'package:flutter/material.dart';
import 'package:living_way/controllers/auth_controller.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/screens/AuthScreens/login_screen.dart';
import 'package:living_way/screens/AuthScreens/signup_screen.dart';
import 'package:living_way/screens/IntroScreens/intro_screen.dart';
import 'package:living_way/screens/IntroScreens/splash_screen.dart';
import 'package:living_way/screens/Settings/about_screen.dart';
import 'package:living_way/screens/Settings/contacts_screen.dart';
import 'package:living_way/screens/Settings/donation_screen.dart';
import 'package:living_way/screens/Settings/ProfileSettingsScreen/index.dart';
import 'package:living_way/screens/Settings/settings_screen.dart';
import 'package:living_way/screens/home.dart';
import 'package:living_way/screens/search_screen.dart';
import 'package:living_way/themes/dark_theme.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class LivingWayApp extends StatelessWidget {
  const LivingWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthController>(
              create: (_) => AuthController()),
          ChangeNotifierProvider<LayoutController>(
              create: (_) => LayoutController()),
          ChangeNotifierProvider<ContentController>(
              create: (_) => ContentController()),
          ChangeNotifierProvider<ProfileController>(
              create: (_) => ProfileController())
        ],
        child: Consumer<AuthController>(builder: (context, authController, _) {
          final profileController = Provider.of<ProfileController>(context);

          authController.setProfileController = profileController;
          
          return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 3)),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.done
                    ? MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Living Way',
                        theme: lightTheme,
                        darkTheme: darkTheme,
                        home: authController.isLoggedIn
                            ? const HomeScreen()
                            : const IntroScreen(),
                        routes: {
                            '/intro': (context) => const IntroScreen(),
                            '/login': (context) => const LoginScreen(),
                            '/signup': (context) => const SignupScreen(),
                            '/home': (context) => const HomeScreen(),
                            '/search': (context) => const SearchScreen(),
                            '/settings': (context) => const SettingsScreen(),
                            '/profile': (context) =>
                                const ProfileSettingsScreen(),
                            '/contacts': (context) => const ContactsScreen(),
                            '/about': (context) => const AboutScreen(),
                            '/donation': (context) => const DonationScreen()
                          })
                    : MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: SplashScreen(context));
              });
        }));
  }
}
