import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/models/translation.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class TranslationPopupButton extends StatelessWidget {
  const TranslationPopupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    
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
                    style: const TextStyle(
                        color: lightPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10)))),
        itemBuilder: (context) => contentController.translations
            .map<PopupMenuItem<Translation>>((translation) => PopupMenuItem(
                onTap: () {
                  if (translation.isAvailabe) {
                    contentController.setTranslation = translation;

                    return;
                  }

                  if (translation.downloadUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: lightPendingColor,
                        content: Row(children: [
                          Text('Coming Soon'),
                          //TODO: Add a notify me to get a push notification
                        ])));
                  } else {
                    //TODO: Download translation
                  }
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(translation.name,
                          style: TextStyle(
                              color: !translation.isAvailabe &&
                                      translation.downloadUrl == null
                                  ? lightPendingColor
                                  : lightPrimaryColor)),
                      if (!translation.isAvailabe &&
                          translation.downloadUrl != null)
                        const Icon(Icons.download_rounded,
                            color: lightPrimaryColor),
                      if (!translation.isAvailabe &&
                          translation.downloadUrl == null)
                        SvgPicture.asset(AppIcons.pending,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                                lightPendingColor, BlendMode.srcIn))
                    ])))
            .toList());
  }
}
