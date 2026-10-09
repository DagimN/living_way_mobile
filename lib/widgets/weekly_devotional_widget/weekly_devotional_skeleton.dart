import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class WeeklyDevotionalSkeleton extends StatelessWidget {
  const WeeklyDevotionalSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;
    final baseColor = theme.backgroundColor;

    Widget placeholder(double width, double height, {double radius = 4}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Shimmer.fromColors(
      direction: ShimmerDirection.rtl,
      baseColor: baseColor,
      highlightColor: theme.primaryColor.withAlpha(120),
      child: Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      placeholder(104, 14),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          placeholder(58, 20),
                          const SizedBox(width: 6),
                          placeholder(72, 12),
                        ],
                      ),
                    ],
                  ),
                  placeholder(40, 40, radius: 12),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == 3
                            ? theme.accentColor.withAlpha(30)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: index == 3
                            ? Border.all(color: theme.accentColor, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        children: [
                          placeholder(20, 11),
                          const SizedBox(height: 6),
                          placeholder(15, 16),
                          const SizedBox(height: 6),
                          placeholder(6, 6, radius: 3),
                        ],
                      ),
                    ),
                  ),
                ),
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
              child: Row(
                children: [
                  placeholder(26, 26, radius: 13),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        placeholder(150, 14),
                        const SizedBox(height: 6),
                        placeholder(100, 12),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  placeholder(18, 18, radius: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
