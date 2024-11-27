import 'package:flutter/material.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/utils/format_time.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final layoutController = Provider.of<LayoutController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final appLocale = themeController.appLocale;
    final willRemindPrayer = profileController.willRemindPrayer;
    final prayerTimes = profileController.prayerTimes;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    double textSize = themeController.textSize;
    Fonts selectedFont = themeController.selectedFont;

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

                                    themeController.toggleBrightness();
                                  },
                                  icon: Icon(themeController.brightness ==
                                          Brightness.dark
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

                                    themeController.toggleAppLocale();
                                  },
                                  child: Text(appLocale.name.toUpperCase()))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Font',
                                  style: TextStyle(
                                      fontFamily: selectedFont.name,
                                      fontSize: 47 * textSize)),
                              DropdownButton(
                                  value: themeController.selectedFont,
                                  underline: const SizedBox(),
                                  iconEnabledColor: lightPrimaryColor,
                                  style: TextStyle(
                                      color: lightPrimaryColor,
                                      fontFamily: selectedFont.name,
                                      fontSize: 47 * textSize),
                                  items: Fonts.values
                                      .map((font) => DropdownMenuItem(
                                          value: font,
                                          child: Text(font.name,
                                              style: TextStyle(
                                                  fontFamily: font.name))))
                                      .toList(),
                                  onChanged: (value) {
                                    themeController.setFont =
                                        value ?? Fonts.RobotoSlab;
                                  })
                            ]),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Text Size',
                                  style: TextStyle(
                                      fontSize: 47 * textSize,
                                      fontFamily: selectedFont.name)),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      (themeController.textSize * 100)
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                          fontFamily: selectedFont.name,
                                          fontSize: 47 * textSize,
                                          color: lightPrimaryColor)))
                            ]),
                        Slider(
                            value: themeController.textSize,
                            min: 0.1,
                            max: 1,
                            divisions: 9,
                            activeColor: lightPrimaryColor,
                            onChanged: (value) {
                              themeController.setTextSize = value;
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
                                      profileController.willReceiveNotification,
                                  onChanged: (value) {
                                    profileController
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
                                    profileController.setWillRemindPrayer =
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
                                              profileController
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
