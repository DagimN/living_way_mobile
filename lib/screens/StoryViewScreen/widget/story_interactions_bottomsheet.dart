import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/core/models/user_interaction.dart';

class StoryInteractionsBottomsheet extends StatelessWidget {
  final List<UserInteraction> interactions;

  const StoryInteractionsBottomsheet({super.key, required this.interactions});

  static Future<void> show(BuildContext context,
      {required List<UserInteraction> interactions}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          StoryInteractionsBottomsheet(interactions: interactions),
    );
  }

  List<(UserInteraction, int)> _flattenInteractions() {
    final flattened = <(UserInteraction, int)>[];

    void addInteractions(List<UserInteraction> items, int depth) {
      for (final interaction in items) {
        flattened.add((interaction, depth));
        addInteractions(interaction.subInteractions, depth + 1);
      }
    }

    addInteractions(interactions, 0);
    return flattened;
  }

  String _interactionContent(UserInteraction interaction) {
    final content = interaction.content;
    if (content is Poll) {
      return [
        content.title,
        ...content.options.map((option) => '• ${option.title}'),
      ].join('\n');
    }

    if (content == null) return '';
    if (content is String) return content;
    return content.toString();
  }

  String _authorName(UserInteraction interaction) {
    if (interaction.isAnonymous) return Tr.t('anonymous');
    return '${interaction.user.firstName} ${interaction.user.lastName}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _flattenInteractions();
    final maxHeight = MediaQuery.sizeOf(context).height * .75;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF171717),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (entries.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    Tr.t('noStoryInteractions'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final (interaction, depth) = entries[index];
                      final author = _authorName(interaction);
                      final content = _interactionContent(interaction);
                      final profileImage = interaction.user.profileImageUrl;

                      return Container(
                        margin: EdgeInsets.only(left: depth * 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white12,
                                  backgroundImage: !interaction.isAnonymous &&
                                          profileImage != null
                                      ? NetworkImage(profileImage)
                                      : null,
                                  child: interaction.isAnonymous ||
                                          profileImage == null
                                      ? const Icon(Icons.person,
                                          size: 18, color: Colors.white70)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    author.isEmpty
                                        ? interaction.user.email
                                        : author,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  formatDateTime(interaction.createdAt),
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 11),
                                ),
                              ],
                            ),
                            if (content.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                content,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                            if (interaction.reactions.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: interaction.reactions
                                    .map((reaction) => Chip(
                                          visualDensity: VisualDensity.compact,
                                          backgroundColor: Colors.white12,
                                          label: Text(
                                            '${reaction.reactionType} ${reaction.user.firstName}',
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
