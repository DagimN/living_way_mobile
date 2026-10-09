import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class DevotionalDetailBottomSheet extends StatelessWidget {
  final DateTime date;
  final DevotionItem? item;
  final bool isLocked;

  const DevotionalDetailBottomSheet({
    super.key,
    required this.date,
    this.item,
    required this.isLocked,
  });

  static void show(BuildContext context,
      {required DateTime date, DevotionItem? item, required bool isLocked}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DevotionalDetailBottomSheet(
        date: date,
        item: item,
        isLocked: isLocked,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final layoutController = Provider.of<LayoutController>(context);
    final bibleController = Provider.of<BibleController>(context);
    final screenWidth = MediaQuery.sizeOf(context).width;

    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);
    final bool isCompleted =
        item != null ? item!.isDevotionItemCompleted : false;

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.inactiveColor.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Date & Close row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Tr.t('devotionalReading'),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: theme.primaryColor.withAlpha(160),
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: screenWidth * .65,
                    child: Text(
                      formattedDate,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: theme.primaryColor),
                style: IconButton.styleFrom(
                  backgroundColor: theme.chipColor.withAlpha(60),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          if (isLocked) ...[
            // Locked content state
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(20),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withAlpha(80)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.lock_clock_rounded,
                    size: 48,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Tr.t("lockedDevotionItemTitle"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Tr.arg('lockedDevotionItemSubtitle',
                        DateFormat('MMMM d').format(date)),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.primaryColor.withAlpha(200),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(Tr.t('readingLocked')),
                ],
              ),
            ),
          ] else if (item == null) ...[
            // No item state
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Text(
                Tr.t("devotionItemUnavailable"),
                style: TextStyle(fontSize: 14, color: theme.inactiveColor),
              ),
            ),
          ] else ...[
            // Unlocked Item details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryPanelColor.withAlpha(30),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted
                      ? theme.successColor.withAlpha(80)
                      : theme.dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? theme.successColor.withAlpha(30)
                              : theme.pendingColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 14,
                              color: isCompleted
                                  ? theme.successColor
                                  : theme.pendingColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isCompleted ? Tr.t('completed') : Tr.t('pending'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isCompleted
                                    ? theme.successColor
                                    : theme.pendingColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.menu_book_rounded,
                                size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              item!.passage.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item!.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  if (item!.subTitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item!.subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.primaryColor.withAlpha(180),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Navigation Button to Bible Screen & Completion Toggle Button
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      item!.toggleDevotionItemCompletion();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isCompleted
                              ? Tr.t("markedPending")
                              : Tr.t("markedCompleted")),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCompleted
                              ? Icons.undo_rounded
                              : Icons.check_circle_outline_rounded,
                          color: isCompleted
                              ? theme.pendingColor
                              : theme.successColor,
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            isCompleted
                                ? Tr.t('markPending')
                                : Tr.t('markDone'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isCompleted
                                  ? theme.pendingColor
                                  : theme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                        color: isCompleted
                            ? theme.pendingColor
                            : theme.successColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to Bible screen to exact verse
                      bibleController.setBook = item!.passage.book;
                      bibleController.setChapter = item!.passage.chapter;
                      bibleController.setVerse = item!.passage.verse;
                      bibleController.setPassage = item!.passage;
                      layoutController.setSelectedHomePageNavigation =
                          HomePageNavigation.bible;

                      Future.delayed(
                          const Duration(seconds: 2),
                          () => layoutController.scrollToVerse(
                              layoutController.verseKeys[item!.passage.verse]));

                      if (ModalRoute.of(context)?.settings.name != '/home') {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.auto_stories_rounded,
                        color: Colors.white),
                    label: Text(
                      Tr.t('readPassage'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryButtonColor,
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
