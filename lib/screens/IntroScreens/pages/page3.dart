import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(children: [
      Container(
          height: screenHeight * .37,
          margin: const EdgeInsets.all(14),
          child: const Column(children: [
            Text('Sharing the Gospel, Transforming Lives',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            SizedBox(height: 14),
            Text(
                "We are a church committed to proclaiming the Good News of salvation. Through various ministries and outreach efforts, we strive to reach people with the love of Christ.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
      Image.asset(AppImages.signupFlow2,
          height: screenHeight * .45, fit: BoxFit.cover)
    ]);
  }
}
