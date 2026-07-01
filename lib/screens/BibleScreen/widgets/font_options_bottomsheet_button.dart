import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class FontOptionsBottomsheetButton extends StatelessWidget {
  const FontOptionsBottomsheetButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);
    Fonts selectedFont = themeController.selectedFont;

    return IconButton(
        icon: const Icon(Icons.text_fields_rounded),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                                      parameters: {'font': selectedFont.name});
                                  themeController.setFont = selectedFont;
                                })
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Tr.t('settings.textSize'),
                                style: TextStyle(color: theme.accentColor)),
                            Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(
                                    (themeController.textSize * 100)
                                        .toInt()
                                        .toString(),
                                    style: TextStyle(
                                        color:
                                            AppTheme(themeController.brightness)
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
                                parameters: {'size': value.toStringAsFixed(2)});
                            themeController.setTextSize = value;
                          }),
                    ]),
                  ));
        });
  }
}
