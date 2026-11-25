import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class ReactionPickerBar extends StatefulWidget {
  final List<UserInteraction> interactions;
  final ValueChanged<String> onEmojiSelected;

  const ReactionPickerBar({
    super.key,
    required this.interactions,
    required this.onEmojiSelected,
  });

  @override
  State<ReactionPickerBar> createState() => _ReactionPickerBarState();
}

class _ReactionPickerBarState extends State<ReactionPickerBar> {
  final List<String> _reactionOptions = ['👍', '❤️', '🙌', '🙏'];

  String? _selectedReaction;
  bool _showFullPicker = false;

  Map<String, int> _reactionCounts(
      List<UserInteraction> entries, Profile? userProfile) {
    final usersByReaction = <String, Set<String>>{};
    for (final interaction in entries) {
      if (interaction.type != InteractionType.reaction) continue;

      usersByReaction
          .putIfAbsent(interaction.content, () => <String>{})
          .add(interaction.user.id);

      if (!_reactionOptions.contains(interaction.content)) {
        _reactionOptions.add(interaction.content);
      }

      if (interaction.user.id == userProfile?.id) {
        setState(() {
          _selectedReaction = interaction.content;
        });
      }
    }
    return usersByReaction
        .map((reaction, users) => MapEntry(reaction, users.length));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final profile = Provider.of<ProfileController>(context).userProfile;
    final reactionCounts = _reactionCounts(widget.interactions, profile);
    final screenSize = MediaQuery.sizeOf(context);

    return Column(
      spacing: 4,
      children: [
        if (_showFullPicker)
          SizedBox(
            width: screenSize.width * .9,
            height: screenSize.height * .3,
            child: EmojiPicker(
              onEmojiSelected: (_, value) {
                widget.onEmojiSelected(value.emoji);
              },
              config: Config(
                  height: 280,
                  bottomActionBarConfig:
                      const BottomActionBarConfig(enabled: false),
                  emojiViewConfig: EmojiViewConfig(
                      backgroundColor: Colors.grey.shade900,
                      emojiSizeMax: 24,
                      noRecents: Text(
                        Tr.t('noRecents'),
                        style: const TextStyle(
                            fontSize: 20, color: Color(0xFF818D95)),
                        textAlign: TextAlign.center,
                      )),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: Colors.grey.shade900,
                    indicatorColor: theme.primaryColor,
                    iconColorSelected: theme.primaryColor,
                  )),
            ),
          ),
        SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _reactionOptions.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isCustom = index == _reactionOptions.length;
              final emoji = isCustom ? "" : _reactionOptions[index];
              final selected = _selectedReaction == emoji;

              return index == _reactionOptions.length
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(
                            color: Colors.white24,
                          )),
                      onPressed: () =>
                          setState(() => _showFullPicker = !_showFullPicker),
                      child: Icon(
                          _showFullPicker
                              ? Icons.close
                              : Icons.add_reaction_outlined,
                          size: 18,
                          color: Colors.white70),
                    )
                  : ChoiceChip(
                      selected: selected,
                      onSelected: (isSelected) {
                        setState(() {
                          _selectedReaction = isSelected ? emoji : null;
                        });
                        widget.onEmojiSelected(emoji);
                      },
                      label: Text('$emoji ${reactionCounts[emoji] ?? ""}'),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 13,
                      ),
                      backgroundColor: Colors.black,
                      selectedColor: theme.primaryColor,
                      side: BorderSide(
                        color: selected ? theme.primaryColor : Colors.white24,
                      ),
                      showCheckmark: false,
                      visualDensity:
                          const VisualDensity(horizontal: -3, vertical: -3),
                    );
            },
          ),
        ),
      ],
    );
  }
}
