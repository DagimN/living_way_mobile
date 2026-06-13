import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/AuthScreens/Forms/forgot_password_form.dart';
import 'package:living_way/screens/screens.dart';
import 'package:provider/provider.dart';

class LivingWayApp extends StatelessWidget {
  const LivingWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocalizationController>(
          create: (_) => LocalizationController(),
        ),
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
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
      child: Consumer<LocalizationController>(
          builder: (context, localizationController, _) {
        return FutureBuilder(
            future: localizationController.isInitialized
                ? null
                : localizationController.init(),
            builder: (context, asyncSnapshot) {
              return EasyLocalization(
                supportedLocales: localizationController.supportedLocales,
                path: 'assets/translations',
                fallbackLocale: localizationController.supportedLocales.first,
                assetLoader: localizationController.loader,
                saveLocale: false,
                child: Consumer<AuthController>(
                    builder: (context, authController, _) {
                  final profileController =
                      Provider.of<ProfileController>(context);
                  final layoutController =
                      Provider.of<LayoutController>(context);
                  final themeController = Provider.of<ThemeController>(context);
                  final bibleController = Provider.of<BibleController>(context);

                  Provider.of<ContentController>(context);
                  Provider.of<NotificationController>(context);
                  Provider.of<ActivityController>(context);
                  Provider.of<DevotionController>(context);

                  authController.setProfileController = profileController;
                  layoutController.setBibleController = bibleController;

                  return !layoutController.showSplashScreen
                      ? MaterialApp(
                          navigatorKey: UIService.navigatorKey,
                          navigatorObservers: [
                            FirebaseAnalyticsObserver(
                                analytics: FirebaseAnalytics.instance)
                          ],
                          scaffoldMessengerKey: UIService.messengerKey,
                          debugShowCheckedModeBanner: false,
                          title: 'Living Way',
                          localizationsDelegates: context.localizationDelegates,
                          supportedLocales: context.supportedLocales,
                          locale: context.locale,
                          theme: ThemeData(
                              colorScheme: ColorScheme.fromSeed(
                                  seedColor:
                                      AppTheme(themeController.brightness)
                                          .primaryColor),
                              useMaterial3: true),
                          home: const HomeScreen(),
                          routes: {
                            '/intro': (context) => const IntroScreen(),
                            '/login': (context) => const LoginScreen(),
                            '/signup': (context) => const SignupScreen(),
                            '/home': (context) => const HomeScreen(),
                            '/search': (context) => const SearchScreen(),
                            '/settings': (context) =>
                                const GeneralSettingsScreen(),
                            '/profile': (context) =>
                                const ProfileSettingsScreen(),
                            '/contacts': (context) => const ContactsScreen(),
                            '/about': (context) => const AboutScreen(),
                            '/donation': (context) => const DonationScreen(),
                            '/notifications': (context) =>
                                const NotificationScreen(),
                            '/forgot-password': (context) =>
                                const ForgotPasswordForm(),
                          })
                      : MaterialApp(
                          debugShowCheckedModeBanner: false,
                          navigatorObservers: [
                            FirebaseAnalyticsObserver(
                                analytics: FirebaseAnalytics.instance)
                          ],
                          home: SplashScreen(context));
                }),
              );
            });
      }),
    );
  }
}
