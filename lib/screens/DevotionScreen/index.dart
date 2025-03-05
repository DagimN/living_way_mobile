import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/screens/DevotionScreen/widgets/topics_listview.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:living_way/widgets/base_app_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DevotionScreen extends StatelessWidget {
  const DevotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      BaseAppBar(
          title: Container(
              margin: const EdgeInsets.all(10),
              child: Text('Today',
                  style: TextStyle(
                      fontSize: 32,
                      color: AppTheme(themeController.brightness).iconColor,
                      fontWeight: FontWeight.w400)))),
      Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
              width: screenWidth * .9,
              height: screenHeight * .35,
              child: Lottie.asset('assets/animations/reading_book.json'))),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(AppIcons.quote,
                height: 40,
                colorFilter: ColorFilter.mode(
                    AppTheme(themeController.brightness).primaryColor,
                    BlendMode.srcIn)),
            const SizedBox(width: 10),
            SizedBox(
                width: screenWidth * .7,
                child: const Text(
                    'Your word is a lamp for my feet, a light on my path.',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Ephesis',
                        fontSize: 20)))
          ])),
      SizedBox(height: screenHeight * .03),
      const TopicsListview()
    ])));
  }
}
