import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(children: [
      Container(
          height: screenHeight * .37,
          margin: const EdgeInsets.all(14),
          child: Column(children: [
            Text(Tr.t('page3Title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    color: theme.accentColor)),
            const SizedBox(height: 14),
            Text(Tr.t('page3Subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    color: theme.accentColor))
          ])),
      Image.asset(AppImages.signupFlow2,
          height: screenHeight * .45, fit: BoxFit.cover)
    ]);
  }
}
