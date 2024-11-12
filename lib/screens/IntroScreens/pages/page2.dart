import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          height: screenHeight * .5,
          margin: const EdgeInsets.all(14),
          child: const Column(children: [
            Text('A Community of Believers',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            SizedBox(height: 14),
            Text(
                "Join us as we journey together towards a deeper understanding of God's Word and a closer walk with Christ. We are a community dedicated to spiritual growth and mutual support.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
      Image.asset(AppImages.signupFlow1,
          height: screenHeight * .27, fit: BoxFit.cover)
    ]);
  }
}
