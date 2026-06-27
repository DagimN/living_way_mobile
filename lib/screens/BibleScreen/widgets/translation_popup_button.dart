import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class TranslationPopupButton extends StatelessWidget {
  const TranslationPopupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bibleController = Provider.of<BibleController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return PopupMenuButton<Translation>(
        initialValue: bibleController.translation,
        color: theme.chipColor,
        child: Container(
            width: 50,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: theme.chipColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(bibleController.translation.name,
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10)))),
        itemBuilder: (context) => bibleController.translations
            .map<PopupMenuItem<Translation>>((translation) => PopupMenuItem(
                onTap: () async {
                  if (translation.status == TranslationStatus.available) {
                    bibleController.setTranslation = translation;
                    AnalyticsService.logEvent('translation_selected',
                        parameters: {'translation': translation.name});
                    return;
                  }

                  if (translation.status == TranslationStatus.pending) {
                    UIService.showSnackbar(
                        backgroundColor:
                            AppTheme(themeController.brightness).pendingColor,
                        message: Tr.t('settings.comingSoon'));
                  }

                  if (translation.status == TranslationStatus.ready) {
                    bibleController.downloadTranslation(translation.name);
                    AnalyticsService.logEvent('translation_download_started',
                        parameters: {'translation': translation.name});
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(translation.name,
                          style: TextStyle(
                              color: translation.status ==
                                      TranslationStatus.pending
                                  ? theme.pendingColor
                                  : theme.primaryColor)),
                      if (translation.status == TranslationStatus.ready)
                        Icon(Icons.download_rounded, color: theme.primaryColor),
                      if (translation.status == TranslationStatus.pending)
                        SvgPicture.asset(AppIcons.pending,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                                theme.pendingColor, BlendMode.srcIn))
                    ])))
            .toList());
  }
}
