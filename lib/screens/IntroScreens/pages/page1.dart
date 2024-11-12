import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(AppImages.signupFlow3,
          height: screenHeight * .4, fit: BoxFit.cover),
      Container(
          margin: const EdgeInsets.all(14),
          child: const Column(children: [
            Text('Welcome to Living Way Church',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            SizedBox(height: 14),
            Text('Eternity Matters',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ]))
    ]);
  }
}
