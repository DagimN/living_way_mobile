import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class WhoWeAreTab extends StatelessWidget {
  const WhoWeAreTab({super.key});

  static const List<String> aspirations = [
    "aboutPage.aspireContent.christCentered",
    "aboutPage.aspireContent.focusedEvangelism",
    "aboutPage.aspireContent.discipleMaking",
    "aboutPage.aspireContent.communityLife",
    "aboutPage.aspireContent.friendlyToNewcomers",
    "aboutPage.aspireContent.believersGrowth",
    "aboutPage.aspireContent.broadMinistry",
    "aboutPage.aspireContent.gospelLiving",
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Tr.t('aboutPage.whoWeAreDescription1'),
              style: TextStyle(color: theme.accentColor)),
          const SizedBox(height: 16),
          Text(Tr.t('aboutPage.whoWeAreDescription2'),
              style: TextStyle(color: theme.accentColor)),
          const SizedBox(height: 32),
          Text(Tr.t('aboutPage.aspireTitle'),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: theme.accentColor)),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: aspirations.length,
              itemBuilder: (context, index) {
                final aspiration = aspirations[index];
                return ListTile(
                    leading: const Icon(Icons.circle,
                        color: Colors.orange, size: 14),
                    title: Text(Tr.t(aspiration),
                        style: TextStyle(color: theme.accentColor)));
              })
        ])));
  }
}
