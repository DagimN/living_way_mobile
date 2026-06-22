import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

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
    return Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(Tr.t('aboutPage.whoWeAreDescription1')),
          const SizedBox(height: 16),
          Text(Tr.t('aboutPage.whoWeAreDescription2')),
          const SizedBox(height: 32),
          Text(Tr.t('aboutPage.aspireTitle'),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: aspirations.length,
              itemBuilder: (context, index) {
                final aspiration = aspirations[index];
                return ListTile(
                    leading: const Icon(Icons.circle,
                        color: Colors.orange, size: 14),
                    title: Text(Tr.t(aspiration)));
              })
        ])));
  }
}
