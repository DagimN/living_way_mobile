import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        width: screenWidth * .75,
        height: screenHeight * .15,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text('Gallery')));
  }
}
