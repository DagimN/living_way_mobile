import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'widgets/legend_item.dart';
import 'widgets/month_grid.dart';

class DevotionalCalendarScreen extends StatefulWidget {
  const DevotionalCalendarScreen({super.key});

  @override
  State<DevotionalCalendarScreen> createState() =>
      _DevotionalCalendarScreenState();
}

class _DevotionalCalendarScreenState extends State<DevotionalCalendarScreen> {
  int _selectedYear = DateTime.now().year;
  late final ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_scrollControllerInitialized) {
      final monthExtent = MediaQuery.sizeOf(context).width - 32;
      _scrollController = ScrollController(
        initialScrollOffset:
            16 + (DateTime.now().month - 1) * (monthExtent + 20),
      );
      _scrollControllerInitialized = true;
    }
  }

  bool _scrollControllerInitialized = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context).theme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
          backgroundColor: theme.appbarColor,
          foregroundColor: theme.inactiveChipColor ?? Colors.white,
          systemOverlayStyle: theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          title: Text(Tr.t('devotionalPlan'))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear--;
                        });
                      },
                      icon: Icon(Icons.chevron_left_rounded,
                          color: theme.primaryColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_selectedYear',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _selectedYear++;
                        });
                      },
                      icon: Icon(Icons.chevron_right_rounded,
                          color: theme.primaryColor),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.primaryPanelColor.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LegendItem(
                  color: theme.successColor,
                  icon: Icons.circle,
                  label: Tr.t('completed'),
                ),
                LegendItem(
                    color: theme.primaryColor,
                    icon: Icons.radio_button_unchecked,
                    label: Tr.t('pending')),
                LegendItem(
                  color: theme.primaryColor,
                  icon: Icons.lock_outline_rounded,
                  label: Tr.t('locked'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              itemCount: 12,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, monthIndex) => SizedBox(
                height: MediaQuery.sizeOf(context).width - 32,
                child: MonthGrid(
                  year: _selectedYear,
                  month: monthIndex + 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
