import 'package:flutter/material.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/utils/format_time.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final appLocale = layoutController.appLocale;
    final isDarkMode = layoutController.isDarkMode;
    final willRemindPrayer = layoutController.willRemindPrayer;
    final prayerTimes = profileController.prayerTimes;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: SafeArea(
                child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back,
                            color: lightPrimaryColor)),
                    const Text('General',
                        style: TextStyle(
                            fontSize: 32,
                            color: lightPrimaryColor,
                            fontWeight: FontWeight.w300))
                  ])),
              Container(
                  height: orientation == Orientation.portrait
                      ? screenHeight * .85
                      : screenWidth * .3,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        const Text("Interface",
                            style: TextStyle(
                                color: lightPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Theme'),
                              IconButton(
                                  style: IconButton.styleFrom(
                                      foregroundColor: lightPrimaryColor),
                                  onPressed: () {
                                    //TODO: Set theme

                                    layoutController.setTheme = !isDarkMode;
                                  },
                                  icon: Icon(isDarkMode
                                      ? Icons.nights_stay
                                      : Icons.sunny))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Language'),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          lightPrimaryColor.withOpacity(0.2),
                                      foregroundColor: lightPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () {
                                    //TODO: Add language locale and make functional

                                    layoutController.setAppLocale =
                                        appLocale == AppLocale.en
                                            ? AppLocale.am
                                            : AppLocale.en;
                                  },
                                  child: Text(appLocale.name.toUpperCase()))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Font'),
                              DropdownButton(
                                  value: layoutController.selectedFont,
                                  underline: const SizedBox(),
                                  iconEnabledColor: lightPrimaryColor,
                                  style:
                                      const TextStyle(color: lightPrimaryColor),
                                  items: layoutController.fonts
                                      .map((font) => DropdownMenuItem(
                                          value: font, child: Text(font)))
                                      .toList(),
                                  onChanged: (value) {
                                    //TODO: Set Font
                                  })
                            ]),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Text Size'),
                              Text(layoutController.textSize.toInt().toString(),
                                  style:
                                      const TextStyle(color: lightPrimaryColor))
                            ]),
                        Slider(
                            value: layoutController.textSize,
                            min: 8,
                            max: 32,
                            divisions: 24,
                            activeColor: lightPrimaryColor,
                            onChanged: (value) {
                              layoutController.setTextSize = value;
                            }),
                        const SizedBox(height: 16),
                        const Text("Reminders",
                            style: TextStyle(
                                color: lightPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Receive notifications"),
                              Switch(
                                  activeColor: lightPrimaryColor,
                                  value:
                                      layoutController.willReceiveNotification,
                                  onChanged: (value) {
                                    layoutController
                                        .setWillReceiveNotification = value;
                                  })
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Prayer Reminder"),
                              Switch(
                                  activeColor: lightPrimaryColor,
                                  value: willRemindPrayer,
                                  onChanged: (value) {
                                    layoutController.setWillRemindPrayer =
                                        value;
                                  })
                            ]),
                        if (willRemindPrayer)
                          Column(children: [
                            TextButton(
                                style: TextButton.styleFrom(
                                    foregroundColor: lightPrimaryColor),
                                onPressed: () {
                                  profileController.addPrayerTime(
                                      const TimeOfDay(hour: 23, minute: 0));
                                },
                                child: const Row(children: [
                                  Icon(Icons.add),
                                  Text('Add Time')
                                ])),
                            ...prayerTimes.map((time) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            //TODO: Edit time of day
                                            showTimePicker(
                                                context: context,
                                                initialTime: time);
                                          },
                                          child: Text(
                                              formatTime(time, appLocale))),
                                      IconButton(
                                          onPressed: () {
                                            if (prayerTimes.length > 1) {
                                              profileController
                                                  .removePrayerTime(prayerTimes
                                                      .indexOf(time));
                                            } else {
                                              layoutController
                                                  .setWillRemindPrayer = false;
                                            }
                                          },
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: lightPrimaryColor))
                                    ]))
                          ])
                      ])))
            ]))));
  }
}
