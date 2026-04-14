import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/models/translation.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:provider/provider.dart';

class TranslationPopupButton extends StatelessWidget {
  const TranslationPopupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final themeController = Provider.of<ThemeController>(context);

    return PopupMenuButton<Translation>(
        initialValue: contentController.translation ??
            contentController.translations.first,
        child: Container(
            width: 50,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
                child: Text(
                    contentController.translation?.name ??
                        contentController.translations.first.name,
                    style: TextStyle(
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10)))),
        itemBuilder: (context) => contentController.translations
            .map<PopupMenuItem<Translation>>((translation) => PopupMenuItem(
                onTap: () {
                  if (translation.status == TranslationStatus.available) {
                    contentController.setTranslation = translation;
                    return;
                  }

                  if (translation.status == TranslationStatus.pending) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor:
                            AppTheme(themeController.brightness).pendingColor,
                        content: const Row(children: [
                          Text('Coming Soon'),
                          //TODO: Add a notify me to get a push notification
                        ])));
                  }

                  if (translation.status == TranslationStatus.ready) {
                    contentController.downloadTranslation(translation.name);
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
