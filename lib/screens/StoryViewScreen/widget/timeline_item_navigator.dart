import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class TimelineItemNavigator extends StatelessWidget {
  final StoryMetadata metadata;
  final double currentSeek;
  const TimelineItemNavigator(
      {super.key, required this.metadata, required this.currentSeek});

  static const _timelineLeadTime = Duration(seconds: 2);
  static const _timelineDisplayGrace = Duration(seconds: 5);

  Duration? _timelinePosition(String? timestamp) {
    if (timestamp == null) return null;

    final value = timestamp.trim();
    if (value.isEmpty) return null;

    final parts = value.split(':');
    if (parts.length == 1) {
      final seconds = double.tryParse(parts.single);
      return seconds == null || seconds < 0
          ? null
          : Duration(milliseconds: (seconds * 1000).round());
    }

    if (parts.length != 2 && parts.length != 3) return null;
    final values = parts.map(double.tryParse).toList();
    if (values.any((part) => part == null || part < 0)) return null;

    final seconds = values.last!;
    final minutes = values[values.length - 2]!;
    final hours = values.length == 3 ? values.first! : 0;
    if (seconds >= 60 || (values.length == 3 && minutes >= 60)) return null;

    final totalSeconds = hours * 3600 + minutes * 60 + seconds;
    return Duration(milliseconds: (totalSeconds * 1000).round());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final layoutController = Provider.of<LayoutController>(context);
    final timeline = metadata.timeline;
    final playbackPosition = Duration(milliseconds: currentSeek.toInt());
    final visibleTimelineItems = timeline.asMap().entries.where((entry) {
      final position = _timelinePosition(entry.value.timestamp);
      final reference = entry.value.reference;

      return position != null &&
          reference != null &&
          playbackPosition >= position - _timelineLeadTime &&
          playbackPosition <= position + _timelineDisplayGrace;
    }).toList();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slideAnimation = animation.drive(
          Tween<Offset>(
            begin: const Offset(0, -0.25),
            end: Offset.zero,
          ).chain(
            CurveTween(curve: Curves.easeOutCubic),
          ),
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      child: visibleTimelineItems.isEmpty
          ? const SizedBox.shrink(key: ValueKey('no-timeline-popup'))
          : Column(
              key: ValueKey(
                  visibleTimelineItems.map((entry) => entry.key).join(',')),
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: visibleTimelineItems.map((entry) {
                final item = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black87,
                      side: BorderSide(color: theme.primaryColor),
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () => item.navigate(layoutController),
                    icon: Icon(
                        item.type?.icon ?? TimelineItemType.undefined.icon),
                    label: Text(
                      item.label.isEmpty
                          ? item.type?.name ?? 'Timeline item' //TODO: Translate
                          : item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
