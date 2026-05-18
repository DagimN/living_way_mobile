import 'package:flutter/material.dart';
// import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/themes/app_theme.dart';
// import 'package:living_way/core/utils/format_time.dart';
import 'package:provider/provider.dart';

class PrayerTimesListView extends StatelessWidget {
  const PrayerTimesListView({super.key});

  @override
  Widget build(BuildContext context) {
    // final profileController = Provider.of<ProfileController>(context);
    final themeController = Provider.of<ThemeController>(context);
    // final prayerTimes = profileController.prayerTimes;
    // final appLocale = themeController.appLocale;

    return Column(children: [
      TextButton(
          style: TextButton.styleFrom(
              foregroundColor:
                  AppTheme(themeController.brightness).primaryColor),
          onPressed: () {
            // profileController
            //     .addPrayerTime(const TimeOfDay(hour: 23, minute: 0));
          },
          child: const Row(children: [Icon(Icons.add), Text('Add Time')])),
      // ...prayerTimes.map((time) =>
      //     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //       TextButton(
      //           onPressed: () async {
      //             final result = await showTimePicker(
      //                 context: context,
      //                 initialTime: time,
      //                 builder: (context, child) => Theme(
      //                     data: ThemeData(
      //                         primaryColor: AppTheme(themeController.brightness)
      //                             .primaryColor,
      //                         timePickerTheme: TimePickerThemeData(
      //                             dayPeriodColor:
      //                                 AppTheme(themeController.brightness)
      //                                     .primaryColor
      //                                     .withAlpha(76))),
      //                     child: child ?? const SizedBox()));

      //             if (result != null) {
      //               profileController.editPrayerTime(
      //                   result, prayerTimes.indexOf(time));
      //             }
      //           },
      //           child: Text(formatTime(time,
      //               appLocale))), When locale is am, it is not clear at what time it is
      //       IconButton(
      //           onPressed: () {
      //             if (prayerTimes.length > 1) {
      //               profileController
      //                   .removePrayerTime(prayerTimes.indexOf(time));
      //             } else {
      //               profileController.setWillRemindPrayer = false;
      //             }
      //           },
      //           icon: Icon(Icons.remove_circle_outline,
      //               color: AppTheme(themeController.brightness).primaryColor))
      //     ]))
    ]);
  }
}
