import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

Duration? _parseTimelineTimestamp(String? timestamp) {
  if (timestamp == null) return null;

  final parts = timestamp.split(':');
  if (parts.length < 2 || parts.length > 3) return null;

  final seconds = double.tryParse(parts.last);
  final minutes = int.tryParse(parts[parts.length - 2]);
  final hours = parts.length == 3 ? int.tryParse(parts.first) : 0;
  if (seconds == null ||
      minutes == null ||
      hours == null ||
      seconds < 0 ||
      seconds >= 60 ||
      minutes < 0 ||
      hours < 0 ||
      (parts.length == 3 && minutes >= 60)) {
    return null;
  }

  final totalSeconds = hours * 3600 + minutes * 60 + seconds;
  return Duration(milliseconds: (totalSeconds * 1000).round());
}

class TimelineBottomsheet extends StatelessWidget {
  final VideoPlayerController controller;
  final List<TimelineItem> timeline;
  const TimelineBottomsheet(
      {super.key, required this.controller, required this.timeline});

  static Future<void> show(BuildContext context,
      {required VideoPlayerController controller,
      required List<TimelineItem> timeline}) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          TimelineBottomsheet(controller: controller, timeline: timeline),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .65),
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
              Text(
                Tr.t("timeline"),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (timeline.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    Tr.t("noTimelineItems"),
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: timeline.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = timeline[index];
                      final type = item.type?.name ?? '';

                      final label = [
                        if (type.isNotEmpty) type,
                        item.label,
                      ].join(' · ');

                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: theme.primaryColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        onPressed: () async {
                          final timestamp =
                              _parseTimelineTimestamp(item.timestamp);
                          if (timestamp != null &&
                              controller.value.isInitialized) {
                            await controller.seekTo(timestamp);
                          }

                          UIService.pop();
                        },
                        child: Row(
                          children: [
                            Icon(item.type?.icon ??
                                TimelineItemType.undefined.icon),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                label.isEmpty ? Tr.t("timelineItem") : label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (item.timestamp != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  item.timestamp!,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ),
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
