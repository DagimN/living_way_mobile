import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'flutter_polls.dart';

class Poll extends StatefulWidget {
  final Activity content;
  final Profile? userProfile;
  const Poll({super.key, required this.content, this.userProfile});

  @override
  State<Poll> createState() => _PollState();
}

class _PollState extends State<Poll> {
  late Activity content = widget.content;
  String? selectedPollId;

  @override
  void initState() {
    super.initState();

    selectedPollId = content.pollOptions
        .where((poll) => poll.voters.contains(widget.userProfile?.id))
        .firstOrNull
        ?.title;
  }

  @override
  Widget build(BuildContext context) {
    final activityController = Provider.of<ActivityController>(context);
    final themeController = Provider.of<ThemeController>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool hasEnded = (content.upcomingDate != null
        ? DateTime.now().compareTo(content.upcomingDate ?? DateTime.now()) > 0
        : !content.isOngoing);

    return SizedBox(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        child: Column(children: [
          FlutterPolls(
              pollId: widget.content.id,
              votedProgressColor: AppTheme(themeController.brightness)
                  .primaryColor
                  .withAlpha(76),
              hasVoted: (selectedPollId != null ||
                  content.pollOptions.any(
                      (poll) => poll.voters.contains(widget.userProfile?.id))),
              pollEnded: hasEnded,
              leadingVotedProgessColor: AppTheme(themeController.brightness)
                  .primaryColor
                  .withAlpha(178),
              userVotedOptionId: selectedPollId,
              pollTitle: selectedPollId != null && !hasEnded
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () async {
                            final poll = widget.content.pollOptions
                                .where((poll) => selectedPollId == poll.title)
                                .first;
                            final pollIndex = content.pollOptions.indexOf(poll);
                            final updatingContent = content;
                            poll.voters.remove(widget.userProfile?.id);
                            updatingContent.pollOptions
                                .replaceRange(pollIndex, pollIndex + 1, [poll]);

                            final success = await activityController
                                .updatePoll(updatingContent);

                            setState(() {
                              selectedPollId = success ? null : selectedPollId;
                              content = success ? updatingContent : content;
                            });
                          },
                          icon: const Icon(Icons.undo)))
                  : const SizedBox(),
              pollOptions: content.pollOptions
                  .map((option) => PollOption(
                      id: option.title,
                      title: Text(option.title),
                      votes: option.voters.length))
                  .toList(),
              onVoted: (pollOption, newTotalVotes) async {
                if (widget.userProfile != null) {
                  final poll = content.pollOptions
                      .where((poll) => pollOption.id == poll.title)
                      .first;
                  final pollIndex = content.pollOptions.indexOf(poll);
                  final updatingContent = content;
                  poll.voters.add(widget.userProfile!.id);
                  updatingContent.pollOptions
                      .replaceRange(pollIndex, pollIndex + 1, [poll]);

                  final success =
                      await activityController.updatePoll(updatingContent);

                  setState(() {
                    selectedPollId = success ? pollOption.id : null;
                    content = success ? updatingContent : content;
                  });

                  return Future.value(success);
                }

                UIService.showSnackbar(
                    backgroundColor: Colors.redAccent,
                    message: 'Failed to save vote');
                return Future.value(false);
              })
        ]));
  }
}
