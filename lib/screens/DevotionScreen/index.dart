import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/screens/DevotionScreen/widgets/topics_listview.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:lottie/lottie.dart';

class DevotionScreen extends StatelessWidget {
  const DevotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            margin: const EdgeInsets.all(10),
            child: const Text('Devotion',
                style: TextStyle(
                    fontSize: 32,
                    color: lightPrimaryColor,
                    fontWeight: FontWeight.w300))),
        IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded,
                color: lightPrimaryColor))
      ]),
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
                colorFilter:
                    const ColorFilter.mode(lightPrimaryColor, BlendMode.srcIn)),
            const SizedBox(width: 10),
            SizedBox(
                width: screenWidth * .7,
                child: const Text(
                    'Your word is a lamp for my feet, a light on my path.',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        //TODO: Add custom font Ephesis
                        fontFamily: 'Ephesis',
                        fontSize: 20)))
          ])),
      SizedBox(height: screenHeight * .03),
      const TopicsListview()
    ])));
  }
}
