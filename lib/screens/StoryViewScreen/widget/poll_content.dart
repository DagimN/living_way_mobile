import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class PollContent extends StatefulWidget {
  final UserInteraction interaction;
  const PollContent({super.key, required this.interaction});

  @override
  State<PollContent> createState() => _PollContentState();
}

class _PollContentState extends State<PollContent> {
  void _toggleVote(PollOptions selectedOption, int optionIndex, String userId) {
    final poll = widget.interaction.content as Poll;

    setState(() {
      final retractVote = selectedOption.voters.contains(userId);

      for (final option in poll.options) {
        option.voters.removeWhere((voterId) => voterId == userId);
      }
      if (!retractVote) selectedOption.voters.add(userId);
    });

    widget.interaction.recordVote(userId, optionIndex);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final userId = Provider.of<ProfileController>(context).userProfile?.id;
    final poll = widget.interaction.content as Poll;
    final totalVotes = poll.options.fold<int>(
      0,
      (total, option) => total + option.voters.length,
    );
    final selectedOption = poll.options
        .where((option) => option.voters.contains(userId))
        .firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          poll.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        ...poll.options.indexed.map((indexedOption) {
          final (index, option) = indexedOption;
          final votes = option.voters.length;
          final progress = totalVotes == 0 ? 0.0 : votes / totalVotes;
          final isSelected = selectedOption == option;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: userId == null
                    ? _showVoteError
                    : () {
                        _toggleVote(option, index, userId);
                      },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primaryColor.withValues(alpha: .14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? theme.primaryColor : Colors.white12,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              option.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Text(
                            '$votes ${votes == 1 ? 'vote' : 'votes'}',
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 12),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            Icon(Icons.check_circle,
                                size: 16, color: theme.primaryColor),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.white12,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(theme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        Text(
          '$totalVotes ${totalVotes == 1 ? 'vote' : 'votes'} total',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  void _showVoteError() {
    final theme = Provider.of<ThemeController>(context, listen: false).theme;
    UIService.pop();
    UIService.showSnackbar(
      backgroundColor: theme.failedColor,
      message: Tr.t('voteError'),
    );
  }
}
