import 'package:flutter/material.dart';
import 'package:living_way/core/core.dart';

class OurBeliefsTab extends StatelessWidget {
  const OurBeliefsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Text(Tr.t('aboutPage.ourBelief.bibleTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.bibleBody')),
              Text(Tr.t('aboutPage.ourBelief.GodTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.GodBody')),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.fatherGodTitle'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.fatherGodBody'))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.sonGodTitle'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.sonGodBody'))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.spiritGodTitle'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.spiritGodBody'))),
              Text(Tr.t('aboutPage.ourBelief.manTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.manBody')),
              Text(Tr.t('aboutPage.ourBelief.salvationTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.salvationBody')),
              Text(Tr.t('aboutPage.ourBelief.churchTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.churchBody')),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.baptismTitle'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.baptismBody'))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.lordSupperTitle'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.lordSupperBody'))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.marriageTitle'),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14))),
              Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(Tr.t('aboutPage.ourBelief.marriageBody'))),
              Text(Tr.t('aboutPage.ourBelief.angelsTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.angelsBody')),
              Text(Tr.t('aboutPage.ourBelief.secondComingTitle'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Text(Tr.t('aboutPage.ourBelief.secondComingBody')),
            ],
          ),
        ));
  }
}
