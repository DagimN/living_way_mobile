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
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Text(Tr.t('aboutPage.ourBelief.bibleTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.bibleBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.GodTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.GodBody'),
                  style: TextStyle(color: theme.accentColor)),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.fatherGodTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.fatherGodBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.sonGodTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.sonGodBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.spiritGodTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.spiritGodBody'),
                      style: TextStyle(color: theme.accentColor))),
              Text(Tr.t('aboutPage.ourBelief.manTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.manBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.salvationTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.salvationBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.churchTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.churchBody'),
                  style: TextStyle(color: theme.accentColor)),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.baptismTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.baptismBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.lordSupperTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.lordSupperBody'),
                      style: TextStyle(color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.marriageTitle'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: theme.accentColor))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.marriageBody'),
                      style: TextStyle(color: theme.accentColor))),
              Text(Tr.t('aboutPage.ourBelief.angelsTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.angelsBody'),
                  style: TextStyle(color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.secondComingTitle'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: theme.accentColor)),
              Text(Tr.t('aboutPage.ourBelief.secondComingBody'),
                  style: TextStyle(color: theme.accentColor)),
            ],
          ),
        ));
  }
}
