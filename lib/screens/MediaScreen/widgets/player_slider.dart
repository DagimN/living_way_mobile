import 'package:flutter/material.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/utils/format_time.dart';
import 'package:provider/provider.dart';

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
    final theme = Provider.of<ThemeController>(context).theme;
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      type: MaterialType.transparency,
      child: Stack(children: [
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
                activeColor: theme.primaryColor,
                value: value,
                onChanged: onChanged)),
        Positioned(
            top: -2,
            right: 20,
            child: Text(formatDuration(end ~/ 1000),
                style: const TextStyle(color: Colors.white, fontSize: 10)))
      ]),
    );
  }
}
