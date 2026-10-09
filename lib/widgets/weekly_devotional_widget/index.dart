import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/DevotionalCalendarScreen/index.dart';
import 'package:living_way/widgets/devotional_detail_bottom_sheet.dart';
import 'package:living_way/widgets/weekly_devotional_widget/mini_status_dot.dart';
import 'package:provider/provider.dart';

class WeeklyDevotionalWidget extends StatefulWidget {
  const WeeklyDevotionalWidget({super.key});

  @override
  State<WeeklyDevotionalWidget> createState() => _WeeklyDevotionalWidgetState();
}

class _WeeklyDevotionalWidgetState extends State<WeeklyDevotionalWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final devotionController = Provider.of<DevotionController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final bibleController = Provider.of<BibleController>(context);

    final selectedItem = devotionController.getItemForDate(_selectedDate);

    return ListenableBuilder(
        listenable: selectedItem ?? Listenable.merge([]),
        builder: (context, child) {
          final isSelectedLocked = selectedItem?.isDevotionalLocked ?? false;
          final isSelectedCompleted =
              selectedItem != null && selectedItem.isDevotionItemCompleted;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.primaryPanelColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: theme.dividerColor.withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Tr.t('devotionalPlan'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor.withAlpha(180),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                DateFormat('d MMM').format(_selectedDate),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: theme.accentColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                DateFormat('EEEE')
                                    .format(_selectedDate)
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                  color: theme.inactiveColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DevotionalCalendarScreen(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.calendar_month_rounded,
                          color: theme.primaryColor,
                        ),
                        tooltip: Tr.t('viewFullCalendar'),
                        style: IconButton.styleFrom(
                          backgroundColor: theme.backgroundColor.withAlpha(100),
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: DateTime.now().weekDays.map((date) {
                      final isSelected = date.year == _selectedDate.year &&
                          date.month == _selectedDate.month &&
                          date.day == _selectedDate.day;

                      final item = devotionController.getItemForDate(date);
                      final isLocked = item?.isDevotionalLocked ?? false;
                      final isCompleted =
                          item != null && item.isDevotionItemCompleted;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.accentColor.withAlpha(30)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                              border: isSelected
                                  ? Border.all(
                                      color: theme.accentColor, width: 1.5)
                                  : null,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  date.weekdayShort,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? theme.accentColor
                                        : theme.inactiveColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? theme.accentColor
                                        : theme.primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                MiniStatusDot(
                                    isCompleted: isCompleted,
                                    isLocked: isLocked,
                                    itemExists: item != null),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.dividerColor.withAlpha(40)),
                  ),
                  child: isSelectedLocked
                      ? Row(
                          spacing: 12,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lock_clock_rounded,
                                color: theme.primaryColor,
                                size: 20,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Tr.t('futureDevotionalLocked'),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: theme.primaryColor),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Tr.t('devotionItemLocked'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.primaryColor.withAlpha(160),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : selectedItem == null
                          ? Text(
                              Tr.t('devotionItemUnavailable'),
                              style: TextStyle(
                                  fontSize: 13, color: theme.inactiveColor),
                            )
                          : Row(
                              spacing: 12,
                              children: [
                                InkWell(
                                  onTap: () {
                                    selectedItem.toggleDevotionItemCompletion();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelectedCompleted
                                          ? theme.successColor
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelectedCompleted
                                            ? theme.successColor
                                            : theme.inactiveColor,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelectedCompleted
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      DevotionalDetailBottomSheet.show(
                                        context,
                                        date: _selectedDate,
                                        item: selectedItem,
                                        isLocked: isSelectedLocked,
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedItem.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            decoration: isSelectedCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: isSelectedCompleted
                                                ? theme.inactiveColor
                                                : theme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.auto_stories_rounded,
                                              size: 13,
                                              color: theme.accentColor,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              selectedItem.passage.label,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: theme.accentColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      bibleController.setBook =
                                          selectedItem.passage.book;
                                      bibleController.setChapter =
                                          selectedItem.passage.chapter;
                                      bibleController.setVerse =
                                          selectedItem.passage.verse;
                                      bibleController.setPassage =
                                          selectedItem.passage;

                                      layoutController
                                              .setSelectedHomePageNavigation =
                                          HomePageNavigation.bible;

                                      Future.delayed(
                                          const Duration(seconds: 2),
                                          () => layoutController.scrollToVerse(
                                              layoutController.verseKeys[
                                                  selectedItem.passage.verse]));
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: theme.primaryColor,
                                    ),
                                    tooltip: Tr.t('readPassage')),
                              ],
                            ),
                ),
              ],
            ),
          );
        });
  }
}
