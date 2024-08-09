import 'package:flutter/material.dart';

class Article extends StatelessWidget {
const Article({ super.key });

  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        height: screenHeight * .15,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text('Article')));
  }
}