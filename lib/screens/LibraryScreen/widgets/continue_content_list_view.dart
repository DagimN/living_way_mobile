import 'package:flutter/material.dart';

class ContinueContentListView extends StatelessWidget {
  const ContinueContentListView({super.key});

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Continue Reading',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
          Container(
              height: orientation == Orientation.portrait
                  ? screenHeight * .1
                  : screenHeight * .2,
              width: screenWidth,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                    width: orientation == Orientation.portrait
                        ? screenWidth * .65
                        : screenWidth * .5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey),
                      color: Colors.blue,
                    ),
                    margin: const EdgeInsets.only(right: 10),
                    child: Center(child: Text('Update $index')),
                  );
                },
              )),
        ],
      ),
    );
  }
}
