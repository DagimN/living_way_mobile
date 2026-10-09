import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:provider/provider.dart';

import 'day_marker.dart';

class MonthGrid extends StatelessWidget {
  final int year;
  final int month;

  const MonthGrid({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final devotionController = Provider.of<DevotionController>(context);

    final firstDayOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    final startOffset = (firstDayOfMonth.weekday - 1) % 7;
    final monthName = DateFormat('MMM').format(firstDayOfMonth);

    final now = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            monthName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (context, index) {
              if (index < startOffset) {
                return const SizedBox();
              }

              final dayNumber = index - startOffset + 1;
              final date = DateTime(year, month, dayNumber);
              final isToday = now.year == year &&
                  now.month == month &&
                  now.day == dayNumber;

              final item = devotionController.getItemForDate(date);

              return DayMarker(
                date: date,
                item: item,
                isToday: isToday,
              );
            },
          ),
        ),
      ],
    );
  }
}
