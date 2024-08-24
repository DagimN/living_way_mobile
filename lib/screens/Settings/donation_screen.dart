import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: SafeArea(
                child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back,
                            color: lightPrimaryColor)),
                    const Text('Donations',
                        style: TextStyle(
                            fontSize: 32,
                            color: lightPrimaryColor,
                            fontWeight: FontWeight.w300))
                  ])),
              const Expanded(child: Center(child: Text('Coming Soon')))
            ]))));
  }
}
