import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:living_way/models/activity_content.dart';
import 'package:living_way/themes/light_theme.dart';

class Poll extends StatelessWidget {
  final ActivityContent content;
  const Poll({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        child: FlutterPolls(
            pollId: content.id,
            leadingVotedProgessColor: lightPrimaryColor,
            pollTitle: const Text(""),
            pollOptions: content.pollOptions
                .map((option) =>
                    PollOption(title: Text(option.title), votes: option.votes))
                .toList(),
            onVoted: (pollOption, newTotalVotes) {
              return Future.value(true);
            }));
  }
}
