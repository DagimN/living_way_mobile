import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

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
          child: Column(children: [
            Text(Tr.t("intro.page5Title"),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
            const SizedBox(height: 14),
            Text(Tr.t("intro.page5Subtitle"),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w200))
          ])),
    ]);
  }
}
