import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(children: [
      Container(
          height: screenHeight * .35,
          margin: const EdgeInsets.all(14),
          child: Column(children: [
            Text(Tr.t('page4Title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: theme.accentColor)),
            const SizedBox(height: 14),
            Text(Tr.t('page4Subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    color: theme.accentColor))
          ])),
      Image.asset(AppImages.signupFlow4,
          height: screenHeight * .45, fit: BoxFit.cover)
    ]);
  }
}
