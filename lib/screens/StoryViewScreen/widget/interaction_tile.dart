import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart'
    show UserInteraction, Poll, Tr, InteractionType, formatDateTime;
import 'package:provider/provider.dart';

import 'poll_content.dart';

class InteractionTile extends StatelessWidget {
  final UserInteraction interaction;
  final int depth;
  final Function()? onRecordInteractionReaction;
  final Function()? onReplyToInteraction;
  final Function()? onDismissReplying;
  final bool isReplying;

  const InteractionTile(
      {super.key,
      required this.interaction,
      this.depth = 0,
      this.onRecordInteractionReaction,
      this.onReplyToInteraction,
      this.onDismissReplying,
      this.isReplying = false});

  String _interactionContent(UserInteraction interaction) {
    final content = interaction.content;
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
    final theme = Provider.of<ThemeController>(context).theme;
    final profile = Provider.of<ProfileController>(context).userProfile;

    final author = _authorName(interaction);
    final isPoll = interaction.content is Poll;
    final content = isPoll ? null : _interactionContent(interaction);
    final profileImage = interaction.user.profileImageUrl;

    return Container(
      margin: EdgeInsets.only(left: depth * 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: interaction.isPinned || isReplying
              ? theme.primaryColor.withValues(alpha: .12)
              : Colors.white.withValues(alpha: .06),
          borderRadius: BorderRadius.circular(12),
          border: interaction.isPinned
              ? Border.all(color: theme.primaryColor)
              : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white12,
                backgroundImage:
                    !interaction.isAnonymous && profileImage != null
                        ? NetworkImage(profileImage)
                        : null,
                child: interaction.isAnonymous || profileImage == null
                    ? const Icon(Icons.person, size: 18, color: Colors.white70)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  author.isEmpty ? interaction.user.email : author,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                formatDateTime(interaction.createdAt),
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          if (isPoll) ...[
            const SizedBox(height: 10),
            PollContent(interaction: interaction),
          ] else if (content!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  content,
                  style: const TextStyle(color: Colors.white),
                ),
                if (interaction.type == InteractionType.comment && !isReplying)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 4,
                      children: [
                        SizedBox(
                          width: 20,
                          child: IconButton(
                              style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              onPressed: onReplyToInteraction,
                              icon: const Icon(Icons.reply,
                                  color: Colors.white70, size: 16)),
                        ),
                        SizedBox(
                          width: 20,
                          child: IconButton(
                              style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              onPressed: onRecordInteractionReaction,
                              icon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  interaction.reactions.any((reactor) =>
                                          reactor.id == profile?.id)
                                      ? const Icon(Icons.favorite,
                                          color: Colors.red, size: 16)
                                      : const Icon(
                                          Icons.favorite_border_outlined,
                                          color: Colors.white70,
                                          size: 16),
                                  if (interaction.reactions.isNotEmpty)
                                    Text(
                                        interaction.reactions.length.toString())
                                ],
                              )),
                        )
                      ]),
                if (isReplying)
                  IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: onDismissReplying,
                      icon: const Icon(Icons.close,
                          color: Colors.white70, size: 16)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
