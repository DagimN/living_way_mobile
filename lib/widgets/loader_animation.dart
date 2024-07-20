import 'package:flutter/material.dart';

class LoaderAnimation extends StatelessWidget {
  const LoaderAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      Container(
          height: screenHeight * .5,
          width: screenWidth,
          color: Colors.black.withOpacity(0.3)),
      Positioned(
          top: screenHeight * .25,
          left: screenWidth * .45,
          child: const CircularProgressIndicator(color: Colors.white))
    ]);
  }
}
