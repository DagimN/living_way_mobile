import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);
    final localizationController = Provider.of<LocalizationController>(context);
    final layoutController = Provider.of<LayoutController>(context);
    final profileController = Provider.of<ProfileController>(context);
    final activityController = Provider.of<ActivityController>(context);
    final bibleController = Provider.of<BibleController>(context);
    final willRemindPrayer = profileController.willRemindPrayer;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    Fonts selectedFont = themeController.selectedFont;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            child: SafeArea(
                child: SingleChildScrollView(
                    child: Column(children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:
                            Icon(Icons.arrow_back, color: theme.primaryColor)),
                    Text(Tr.t('settings.general'),
                        style: TextStyle(
                            fontSize: 32,
                            color: theme.primaryColor,
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
                        Text(Tr.t("settings.interface"),
                            style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Tr.t('settings.theme'),
                                  style: TextStyle(color: theme.accentColor)),
                              IconButton(
                                  style: IconButton.styleFrom(
                                      foregroundColor: theme.primaryColor),
                                  onPressed: () async {
                                    AnalyticsService.logEvent(
                                        'theme_toggle_requested',
                                        parameters: {
                                          'previous_theme':
                                              themeController.brightness.name
                                        });
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
                              Text(Tr.t('settings.language'),
                                  style: TextStyle(color: theme.accentColor)),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor:
                                          theme.primaryColor.withAlpha(51),
                                      foregroundColor: theme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  onPressed: () async {
                                    AnalyticsService.logEvent(
                                        'language_toggle_requested');
                                    localizationController
                                        .toggleAppLocale(context);
                                    layoutController
                                            .setSelectedHomePageNavigation =
                                        HomePageNavigation.other;
                                  },
                                  onLongPress: () {
                                    localizationController
                                        .fetchFromRemote(null);
                                  },
                                  child: Text(
                                      AppLocale.shortLabel(context.locale)))
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Tr.t('settings.font'),
                                  style: TextStyle(color: theme.accentColor)),
                              DropdownButton(
                                  value: themeController.selectedFont,
                                  underline: const SizedBox(),
                                  iconEnabledColor: theme.primaryColor,
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontFamily: selectedFont.name),
                                  items: Fonts.values
                                      .map((font) => DropdownMenuItem(
                                          value: font,
                                          child: Text(font.name,
                                              style: TextStyle(
                                                  fontFamily: font.name))))
                                      .toList(),
                                  onChanged: (value) async {
                                    final selectedFont =
                                        value ?? Fonts.RobotoSlab;
                                    AnalyticsService.logEvent('font_changed',
                                        parameters: {
                                          'font': selectedFont.name
                                        });
                                    themeController.setFont = selectedFont;
                                  })
                            ]),
                        const SizedBox(height: 10),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Tr.t('settings.textSize'),
                                  style: TextStyle(
                                      fontFamily: selectedFont.name,
                                      color: theme.accentColor)),
                              Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Text(
                                      (themeController.textSize * 100)
                                          .toInt()
                                          .toString(),
                                      style: TextStyle(
                                          color: AppTheme(
                                                  themeController.brightness)
                                              .primaryColor)))
                            ]),
                        Slider(
                            value: themeController.textSize,
                            min: 0.1,
                            max: 1,
                            divisions: 9,
                            activeColor: theme.primaryColor,
                            inactiveColor: theme.backgroundColor,
                            onChanged: (value) async {
                              AnalyticsService.logEvent('text_size_changed',
                                  parameters: {
                                    'size': value.toStringAsFixed(2)
                                  });
                              themeController.setTextSize = value;
                            }),
                        const SizedBox(height: 16),
                        Text(Tr.t("settings.notifications"),
                            style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        const Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Tr.t("settings.receiveNotifications"),
                                  style: TextStyle(color: theme.accentColor)),
                              Switch(
                                  activeThumbColor: theme.primaryColor,
                                  inactiveTrackColor: theme.backgroundColor,
                                  value:
                                      profileController.willReceiveNotification,
                                  onChanged: (isActive) async {
                                    AnalyticsService.logEvent(
                                        'receive_notifications_toggled',
                                        parameters: {
                                          'enabled': isActive.toString()
                                        });
                                    if (isActive) {
                                      activityController
                                          .scheduleActivityNotifications();
                                      bibleController.scheduleVersesOfTheDay();
                                      NotificationService.periodicNotification(
                                          id: NotificationCodes.prayer.value,
                                          title: Tr.t('settings.prayerTime'),
                                          body:
                                              Tr.t('settings.prayerReminder'));
                                    } else {
                                      NotificationService
                                          .cancelAllNotifications();
                                    }

                                    profileController
                                        .setWillReceiveNotification = isActive;
                                  })
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Tr.t("settings.prayerReminder"),
                                  style: TextStyle(color: theme.accentColor)),
                              Switch(
                                  activeThumbColor: theme.primaryColor,
                                  inactiveTrackColor: theme.backgroundColor,
                                  value: willRemindPrayer,
                                  onChanged: (value) async {
                                    AnalyticsService.logEvent(
                                        'prayer_reminder_toggled',
                                        parameters: {
                                          'enabled': value.toString()
                                        });
                                    profileController.setWillRemindPrayer =
                                        value;
                                  })
                            ]),
                        // if (willRemindPrayer) const PrayerTimesListView()
                      ])))
            ])))));
  }
}
