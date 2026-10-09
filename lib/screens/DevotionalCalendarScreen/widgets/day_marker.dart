import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import '../../../widgets/devotional_detail_bottom_sheet.dart';

class DayMarker extends StatelessWidget {
  final DateTime date;
  final DevotionItem? item;
  final bool isToday;

  const DayMarker(
      {super.key,
      required this.date,
      required this.item,
      required this.isToday});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return ListenableBuilder(
        listenable: item ?? Listenable.merge([]),
        builder: (context, child) {
          Widget markerWidget;

          final isCompleted = item?.isDevotionItemCompleted ?? false;
          final isLocked = item?.isDevotionalLocked ?? false;
          final dayLabel = date.day.toString();
          final tooltipDate = DateFormat('MMM d').format(date);

          if (isCompleted) {
            markerWidget = Container(
                decoration: BoxDecoration(
                  color: theme.successColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: Text(dayLabel,
                        style: const TextStyle(color: Colors.white))));
          } else if (isLocked) {
            markerWidget = Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.inactiveColor.withAlpha(120),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.lock_rounded,
                  size: 8,
                  color: theme.inactiveColor.withAlpha(190),
                ),
              ),
            );
          } else if (item != null) {
            markerWidget = Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isToday
                        ? theme.accentColor
                        : theme.primaryColor.withAlpha(140),
                    width: isToday ? 2 : 1.2,
                  ),
                ),
                child: Center(
                    child: Text(dayLabel,
                        style: TextStyle(color: theme.primaryColor))));
          } else {
            markerWidget = Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.inactiveColor.withAlpha(60),
                ),
                child: Center(
                    child: Text(dayLabel,
                        style: TextStyle(
                            color: theme.inactiveColor.withAlpha(1200)))));
          }

          return InkWell(
            onTap: () {
              DevotionalDetailBottomSheet.show(
                context,
                date: date,
                item: item,
                isLocked: isLocked,
              );
            },
            customBorder: const CircleBorder(),
            child: Tooltip(
              message:
                  item != null ? '$tooltipDate: ${item?.title}' : tooltipDate,
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: isToday
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: theme.accentColor, width: 1.5),
                      )
                    : null,
                child: markerWidget,
              ),
            ),
          );
        });
  }
}
