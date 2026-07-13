import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class OurBeliefsTab extends StatelessWidget {
  const OurBeliefsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Text(Tr.t('bibleTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('bibleBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('GodTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('GodBody'), style: TextStyle(color: theme.accentColor)),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('fatherGodTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('fatherGodBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('sonGodTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('sonGodBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('spiritGodTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('spiritGodBody'),
                      style: TextStyle(color: theme.accentColor))),
              Text(Tr.t('manTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('manBody'), style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('salvationTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('salvationBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('churchTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('churchBody'),
                  style: TextStyle(color: theme.accentColor)),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('baptismTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('baptismBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('lordSupperTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('lordSupperBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('marriageTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('marriageBody'),
                      style: TextStyle(color: theme.accentColor))),
              Text(Tr.t('angelsTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('angelsBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('secondComingTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('secondComingBody'),
                  style: TextStyle(color: theme.accentColor)),
            ],
          ),
        ));
  }
}
