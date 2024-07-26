import 'package:flutter/material.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/utils/format_time.dart';

class PlayerSlider extends StatelessWidget {
  final double end;
  final double value;
  final Function(double) onChanged;
  const PlayerSlider(
      {super.key,
      required this.end,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      Positioned(
          top: -2,
          left: 20,
          child: Text(formatDuration((value ~/ 1000)),
              style: const TextStyle(color: Colors.white, fontSize: 10))),
      SizedBox(
          width: screenWidth,
          child: Slider(
              min: 0,
              max: end,
              activeColor: lightPrimaryColor,
              value: value,
              onChanged: onChanged)),
      Positioned(
          top: -2,
          right: 20,
          child: Text(formatDuration(end ~/ 1000),
              style: const TextStyle(color: Colors.white, fontSize: 10)))
    ]);
  }
}
