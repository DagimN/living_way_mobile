import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/layout_controller.dart';
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
          ChangeNotifierProvider<LayoutController>(
              create: (_) => LayoutController()),
          ChangeNotifierProvider<ContentController>(
              create: (_) => ContentController()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Living Way',
            theme: lightTheme,
            darkTheme: darkTheme,
            initialRoute: '/home',
            routes: {
              '/home':(context) => const HomeScreen(),
              '/search': (context) => const SearchScreen()
            }));
  }
}
