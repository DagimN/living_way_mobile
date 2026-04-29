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

    return PopupMenuButton<Translation>(
        initialValue: bibleController.translation,
        child: Container(
            width: 50,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(bibleController.translation.name,
                    style: TextStyle(
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10)))),
        itemBuilder: (context) => bibleController.translations
            .map<PopupMenuItem<Translation>>((translation) => PopupMenuItem(
                onTap: () {
                  if (translation.status == TranslationStatus.available) {
                    bibleController.setTranslation = translation;
                    return;
                  }

                  if (translation.status == TranslationStatus.pending) {
                    UIService.showSnackbar(
                        backgroundColor:
                            AppTheme(themeController.brightness).pendingColor,
                        message: 'Coming Soon');
                  }

                  if (translation.status == TranslationStatus.ready) {
                    bibleController.downloadTranslation(translation.name);
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(translation.name,
                          style: TextStyle(
                              color: translation.status ==
                                      TranslationStatus.pending
                                  ? AppTheme(themeController.brightness)
                                      .pendingColor
                                  : AppTheme(themeController.brightness)
                                      .primaryColor)),
                      if (translation.status == TranslationStatus.ready)
                        Icon(Icons.download_rounded,
                            color: AppTheme(themeController.brightness)
                                .primaryColor),
                      if (translation.status == TranslationStatus.pending)
                        SvgPicture.asset(AppIcons.pending,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                                AppTheme(themeController.brightness)
                                    .pendingColor,
                                BlendMode.srcIn))
                    ])))
            .toList());
  }
}
