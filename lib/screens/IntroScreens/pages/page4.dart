import 'package:flutter/material.dart';
import 'package:living_way/core/config/paths.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(children: [
      Container(
          height: screenHeight * .35,
          margin: const EdgeInsets.all(14),
          child: const Column(children: [
            Text('A Haven for Spiritual Nourishment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            SizedBox(height: 14),
            Text(
                "Discover the joy of connecting with like-minded believers. We invite you to join us for inspiring worship, insightful Bible studies, and meaningful fellowship.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
      Image.asset(AppImages.signupFlow4,
          height: screenHeight * .45, fit: BoxFit.cover)
    ]);
  }
}
