import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: SafeArea(
                child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back,
                            color: AppTheme(themeController.brightness)
                                .primaryColor)),
                    Text(Tr.t('settings.donations'),
                        style: TextStyle(
                            fontSize: 32,
                            color: AppTheme(themeController.brightness)
                                .primaryColor,
                            fontWeight: FontWeight.w300))
                  ])),
              Expanded(child: Center(child: Text(Tr.t('settings.comingSoon'))))
            ]))));
  }
}
