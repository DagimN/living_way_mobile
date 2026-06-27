import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(AppImages.signupFlow3,
          height: screenHeight * .4, fit: BoxFit.cover),
      Container(
          margin: const EdgeInsets.all(14),
          child: Column(children: [
            Text(Tr.t('intro.page1Title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: theme.accentColor)),
            const SizedBox(height: 14),
            Text(Tr.t('intro.page1Subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    color: theme.accentColor))
          ]))
    ]);
  }
}
