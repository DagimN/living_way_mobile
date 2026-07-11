import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class SearchSection<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<T> items;
  final Axis scrollDirection;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final double height;
  final Widget Function(BuildContext, T) itemBuilder;
  final bool isLoading;
  final bool showLabel;
  final String? errorText;

  const SearchSection(
      {super.key,
      required this.title,
      required this.icon,
      required this.items,
      required this.itemBuilder,
      required this.scrollDirection,
      required this.height,
      this.isLoading = false,
      this.showLabel = true,
      this.errorText,
      this.physics,
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);
    final screenWidth = MediaQuery.of(context).size.width;

    if (items.isEmpty && !isLoading && errorText == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel)
            Row(
              spacing: 4,
              children: [
                Icon(icon, color: theme.primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (isLoading && items.isNotEmpty)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.primaryColor,
                    ),
                  ),
                if (items.isNotEmpty)
                  Text(
                    '${items.length}',
                    style: TextStyle(color: theme.primaryColor.withAlpha(153)),
                  ),
              ],
            ),
          if (items.isNotEmpty && showLabel)
            Divider(color: theme.accentColor.withAlpha(61), height: 24),
          if (items.isNotEmpty)
            SizedBox(
              width: screenWidth,
              height: height,
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.only(
                    bottom: scrollDirection == Axis.vertical ? 100 : 0),
                itemBuilder: (context, index) =>
                    itemBuilder(context, items[index]),
                itemCount: items.length,
                scrollDirection: scrollDirection,
                physics: physics,
              ),
            ),
          if ((items.isEmpty || !showLabel) && isLoading) ...[
            const SizedBox(height: 12),
            Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}
