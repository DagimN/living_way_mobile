import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/screens.dart';
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
              create: (_) => ProfileController()),
          ChangeNotifierProvider<ThemeController>(
              create: (_) => ThemeController()),
          ChangeNotifierProvider<NotificationController>(
              create: (_) => NotificationController()),
          ChangeNotifierProvider<ActivityController>(
              create: (_) => ActivityController()),
          ChangeNotifierProvider<DevotionController>(
              create: (_) => DevotionController()),
          ChangeNotifierProvider<BibleController>(
              create: (_) => BibleController()),
        ],
        child: Consumer<AuthController>(builder: (context, authController, _) {
          final profileController = Provider.of<ProfileController>(context);
          final layoutController = Provider.of<LayoutController>(context);
          final themeController = Provider.of<ThemeController>(context);
          final bibleController = Provider.of<BibleController>(context);

          Provider.of<ContentController>(context);
          Provider.of<NotificationController>(context);
          Provider.of<ActivityController>(context);

          authController.setProfileController = profileController;
          layoutController.setBibleController = bibleController;

          return !layoutController.showSplashScreen
              ? MaterialApp(
                  navigatorKey: UIService.navigatorKey,
                  scaffoldMessengerKey: UIService.messengerKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Living Way',
                  theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: AppTheme(themeController.brightness)
                              .primaryColor),
                      useMaterial3: true),
                  home: const HomeScreen(),
                  // authController.isLoggedIn FIXME: Prioritize anonymous login
                  //     ? const HomeScreen()
                  //     : const IntroScreen(),
                  routes: {
                      '/intro': (context) => const IntroScreen(),
                      '/login': (context) => const LoginScreen(),
                      '/signup': (context) => const SignupScreen(),
                      '/home': (context) => const HomeScreen(),
                      '/search': (context) => const SearchScreen(),
                      '/settings': (context) => const GeneralSettingsScreen(),
                      '/profile': (context) => const ProfileSettingsScreen(),
                      '/contacts': (context) => const ContactsScreen(),
                      '/about': (context) => const AboutScreen(),
                      '/donation': (context) => const DonationScreen()
                    })
              : MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: SplashScreen(context));
        }));
  }
}
