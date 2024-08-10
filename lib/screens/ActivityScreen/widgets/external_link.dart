import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/themes/light_theme.dart';

class ExternalLink extends StatelessWidget {
  final ActivityContent content;
  const ExternalLink({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final borderRadius = BorderRadius.circular(15);

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: Colors.grey, width: 0.3)),
        child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Stack(children: [
              Container(
                  width: 45,
                  height: 25,
                  decoration: BoxDecoration(boxShadow: [
                    const BoxShadow(
                        offset: Offset(0, 0),
                        blurRadius: 36,
                        color: lightSecondaryColor),
                    BoxShadow(
                        offset: Offset(screenWidth * .58, 24),
                        blurRadius: 36,
                        color: lightPrimaryColor)
                  ])),
              ClipRRect(
                  borderRadius: borderRadius,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: SizedBox(
                          width: orientation == Orientation.portrait
                              ? screenWidth * .75
                              : screenWidth * .85,
                          height: 55))),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: screenWidth * .45,
                            child: Text(content.body ?? "")),
                        const Icon(Icons.arrow_circle_right_outlined,
                            color: lightPrimaryColor)
                      ]))
            ]),
            onPressed: () {
              showModalBottomSheet(
                  context: context, builder: (context) => Container());
            }));
  }
}
