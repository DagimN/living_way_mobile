import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';

class Page5 extends StatelessWidget {
  const Page5({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Image.asset(AppImages.signupFlow5,
          height: screenHeight * .45, fit: BoxFit.cover),
      Container(
          height: screenHeight * .35,
          margin: const EdgeInsets.all(14),
          child: const Column(children: [
            Text('Becoming More Like Christ, One Day at a Time',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            SizedBox(height: 14),
            Text("Let's strive for holiness together.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
    ]);
  }
}
