import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Column(children: [
      Container(
          height: screenHeight * .35,
          margin: const EdgeInsets.all(14),
          child: Column(children: [
            Text(Tr.t('intro.page4Title'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            const SizedBox(height: 14),
            Text(Tr.t('intro.page4Subtitle'),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
      Image.asset(AppImages.signupFlow4,
          height: screenHeight * .45, fit: BoxFit.cover)
    ]);
  }
}
