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
          color: Colors.black.withAlpha(76)),
      const Center(child: CircularProgressIndicator(color: Colors.white))
    ]);
  }
}
