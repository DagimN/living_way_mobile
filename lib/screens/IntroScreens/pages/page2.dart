import 'package:flutter/material.dart';
import 'package:living_way/core/config/paths.dart';
import 'package:living_way/core/core.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
          height: screenHeight * .5,
          margin: const EdgeInsets.all(14),
          child: Column(children: [
            Text(Tr.t('intro.page2Title'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            const SizedBox(height: 14),
            Text(Tr.t('intro.page2Subtitle'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
      Image.asset(AppImages.signupFlow1,
          height: screenHeight * .27, fit: BoxFit.cover)
    ]);
  }
}
