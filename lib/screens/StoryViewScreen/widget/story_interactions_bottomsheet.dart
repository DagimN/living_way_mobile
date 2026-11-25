import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'poll_content.dart';
import 'reaction_picker_bar.dart';

class StoryInteractionsBottomsheet extends StatefulWidget {
  final Story story;

  const StoryInteractionsBottomsheet({super.key, required this.story});

  @override
  State<StoryInteractionsBottomsheet> createState() =>
      _StoryInteractionsBottomsheetState();

  static Future<void> show(BuildContext context, {required Story story}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StoryInteractionsBottomsheet(story: story),
    );
  }
}

class _StoryInteractionsBottomsheetState
    extends State<StoryInteractionsBottomsheet> {
  final _commentController = TextEditingController();
  late final story = widget.story;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  List<(UserInteraction, int)> _flattenInteractions() {
    final flattened = <(UserInteraction, int)>[];

    void addInteractions(List<UserInteraction> items, int depth) {
      for (final interaction in items) {
        if (!interaction.isFlagged) {
          flattened.add((interaction, depth));
        }

        addInteractions(interaction.subInteractions, depth + 1);
      }
    }

    addInteractions(story.interactions, 0);
    return flattened;
  }

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

  void submitComment(Profile? user) async {
    if (user == null) {
      final theme = Provider.of<ThemeController>(context, listen: false).theme;
      UIService.pop();
      UIService.showSnackbar(
          backgroundColor: theme.failedColor,
          message: Tr.t("interactionLoginError"));
      return;
    }

    final interaction = UserInteraction(
        id: '',
        user: user,
        targetId: story.id,
        target: TargetInteraction.story,
        content: _commentController.text,
        type: InteractionType.comment,
        createdAt: DateTime.now());

    setState(() {
      story.interactions.insert(0, interaction);
      _commentController.clear();
    });

    interaction.recordInteraction();
  }

  void submitReaction(Profile? user, String emoji) async {
    if (user == null) {
      final theme = Provider.of<ThemeController>(context, listen: false).theme;
      UIService.pop();
      UIService.showSnackbar(
          backgroundColor: theme.failedColor,
          message: Tr.t("interactionLoginError"));
      return;
    }

    final interactions = story.interactions;

    UserInteraction? interaction = interactions.firstWhereOrNull(
        (interaction) =>
            interaction.user.id == user.id &&
            interaction.type == InteractionType.reaction);

    if (interaction == null) {
      interaction = UserInteraction(
          id: '',
          user: user,
          targetId: story.id,
          target: TargetInteraction.story,
          content: emoji,
          type: InteractionType.reaction,
          createdAt: DateTime.now());

      interaction.recordInteraction();
      setState(() {
        story.interactions.add(interaction!);
      });
    } else {
      if (emoji == interaction.content) {
        setState(() {
          story.interactions.removeWhere((item) => interaction?.id == item.id);
        });
        interaction.delete();
      } else {
        interaction.content = emoji;
        setState(() {
          story.interactions
              .addOrReplace(interaction!, (item) => item.id == interaction?.id);
        });
        interaction.update();
      }
    }

    Provider.of<ContentController>(context, listen: false)
        .stories
        .addOrReplace(story, (item) => item.id == story.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final profile = Provider.of<ProfileController>(context).userProfile;

    final entries = _flattenInteractions();
    final maxHeight = MediaQuery.sizeOf(context).height * .75;
    final interactions = entries
        .where((entry) => entry.$1.type != InteractionType.reaction)
        .toList();

    interactions.sort(
        (interactionA, interactionB) => interactionB.$1.isPinned ? 1 : -1);

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF171717),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
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
              if (interactions.isEmpty)
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
                    itemCount: interactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final (interaction, depth) = interactions[index];
                      final author = _authorName(interaction);
                      final isPoll = interaction.content is Poll;
                      final content =
                          isPoll ? null : _interactionContent(interaction);
                      final profileImage = interaction.user.profileImageUrl;
                      final reactionUsers = <String, Set<String>>{};
                      for (final reaction in interaction.reactions) {
                        reactionUsers
                            .putIfAbsent(reaction.type, () => <String>{})
                            .add(reaction.user.id);
                      }

                      return Container(
                        margin: EdgeInsets.only(left: depth * 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          //TODO: Highlight a pinned comment
                          //TODO: Add a admin control for posting pinned comments
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
                            if (isPoll) ...[
                              const SizedBox(height: 10),
                              PollContent(interaction: interaction),
                            ] else if (content!.isNotEmpty) ...[
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
                                children: reactionUsers.entries
                                    .map((entry) => Chip(
                                          visualDensity: VisualDensity.compact,
                                          backgroundColor: Colors.white12,
                                          label: Text(
                                            '${entry.key} ${entry.value.length}',
                                            style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ], //TODO: Add a reactions button and a reply button
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 12),
              ReactionPickerBar(
                  interactions:
                      entries.map((interaction) => interaction.$1).toList(),
                  onEmojiSelected: (emoji) => submitReaction(profile, emoji)),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 3,
                onChanged: (value) => setState(() {}),
                style: const TextStyle(color: Colors.white),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    hintText: Tr.t('commentPlaceholder'),
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: .06),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.primaryColor),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send,
                          color: _commentController.text.isEmpty
                              ? Colors.grey
                              : theme.primaryColor),
                      onPressed: _commentController.text.isEmpty
                          ? null
                          : () => submitComment(profile),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
