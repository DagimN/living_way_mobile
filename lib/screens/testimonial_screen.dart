import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:living_way/config/paths.dart';

class TestimonialScreen extends StatelessWidget {
  const TestimonialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(children: [
      SizedBox(
          height: screenHeight * .35,
          child: Stack(children: [
            Image.asset(AppImages.testimonyBackground,
                height: screenHeight * .35, fit: BoxFit.cover),
            Positioned(
                top: screenHeight * .1,
                left: screenWidth * .2,
                child: const Text('TESTIMONY',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 36))),
            Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                  0.15,
                  0.5,
                  0.7,
                  0.85,
                  1
                ],
                        colors: [
                  Colors.transparent,
                  Color(0x3FFFFBDC),
                  Color(0x7FFFFBDC),
                  Color(0xBFFFFBDC),
                  Color(0xFFFFFBDC)
                ])))
          ])),
      SizedBox(
          height: screenHeight * .5,
          child: GridView.builder(
              shrinkWrap: true,
              itemCount: 12,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 15),
              itemBuilder: (context, index) => ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Icon(Icons.play_circle_fill_rounded,
                      color: Color(0xFFFFFBDC)))))
    ]);
  }
}
