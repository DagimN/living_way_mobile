import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:living_way/core/config/paths.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/activity/index.dart';
import 'package:living_way/core/themes/app_theme.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLink extends StatelessWidget {
  final Activity content;
  const ExternalLink({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    final borderRadius = BorderRadius.circular(15);
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return Container(
        width: orientation == Orientation.portrait
            ? screenWidth * .75
            : screenWidth * .85,
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: Colors.grey, width: 0.3)),
        child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Stack(children: [
              Container(
                  width: 45,
                  height: 20,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 36,
                        color: theme.secondaryColor),
                    BoxShadow(
                        offset: Offset(
                            orientation == Orientation.portrait
                                ? screenWidth * .58
                                : screenWidth * .78,
                            24),
                        blurRadius: 36,
                        color: theme.primaryColor)
                  ])),
              ClipRRect(
                  borderRadius: borderRadius,
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: SizedBox(
                          width: orientation == Orientation.portrait
                              ? screenWidth * .75
                              : screenWidth * .85,
                          height: 55))),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: screenWidth * .45,
                            child: Text(content.body ?? "",
                                style: TextStyle(color: theme.accentColor))),
                        Icon(Icons.arrow_circle_right_outlined,
                            color: AppTheme(themeController.brightness)
                                .primaryColor)
                      ]))
            ]),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: theme.backgroundColor,
                  builder: (context) => Container(
                      width: screenWidth,
                      margin: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Text(content.title ?? "",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: theme.accentColor)),
                        Text(content.body ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: theme.accentColor)),
                        Container(
                            height: screenHeight * .28,
                            width: screenHeight * .28,
                            margin: const EdgeInsets.all(24),
                            child: PrettyQrView.data(
                                data: content.externalLink ?? "",
                                errorCorrectLevel: QrErrorCorrectLevel.H,
                                decoration: const PrettyQrDecoration(
                                    image: PrettyQrDecorationImage(
                                        image: AssetImage(
                                            AppImages.logoTransparent))))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          content.externalLink ?? ""));
                                    },
                                    child: Text(content.externalLink ?? "",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline))),
                              ),
                              IconButton(
                                  onPressed: () {
                                    SharePlus.instance.share(ShareParams(
                                        uri: Uri.tryParse(
                                            content.externalLink ?? "")));
                                  },
                                  icon: Icon(Icons.share,
                                      color: theme.accentColor))
                            ])
                      ]))));
            }));
  }
}
