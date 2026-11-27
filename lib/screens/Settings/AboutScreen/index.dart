import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/Settings/AboutScreen/widgets/our_beliefs_tab.dart';
import 'package:living_way/screens/Settings/AboutScreen/widgets/staff_tab.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'widgets/who_we_are_tab.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool isCheckingLatestVersion = false;

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    AppTheme theme = themeController.theme;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            systemOverlayStyle: themeController.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: theme.primaryColor)),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor.withAlpha(35),
                      foregroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10)),
                      elevation: 5,
                      shadowColor: theme.accentColor.withAlpha(40)),
                  child: Row(
                    spacing: 4,
                    children: [
                      Text(Tr.t('faithStatement')),
                      const Icon(Icons.open_in_new)
                    ],
                  ),
                  onPressed: () {
                    const url = appFlavor == "dev"
                        ? Urls.devApiUrl
                        : appFlavor == "staging"
                            ? Urls.stagingApiUrl
                            : Urls.prodApiUrl;

                    launchUrlString('$url/faith_statement.pdf');
                  },
                ),
              ),
            ]),
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            child: SizedBox(
                height: orientation == Orientation.portrait
                    ? screenHeight * .89
                    : screenHeight * .79,
                child: SingleChildScrollView(
                    child: Column(children: [
                  const SizedBox(height: 100),
                  Image.asset(AppImages.aboutLogo,
                      height: orientation == Orientation.portrait
                          ? screenHeight * .3
                          : screenHeight * .4,
                      width: screenWidth * .7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isCheckingLatestVersion
                          ? const SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                color: Color(0xFF5B89AE),
                                strokeWidth: 2,
                              ),
                            )
                          : InkWell(
                              child: Text(Tr.t('checkUpdates'),
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xFF5B89AE),
                                      decorationColor: Color(0xFF5B89AE),
                                      fontSize: 12)),
                              onTap: () async {
                                setState(() {
                                  isCheckingLatestVersion = true;
                                });
                                final isLatest =
                                    await VersionCheckService.checkForUpdate();
                                setState(() {
                                  isCheckingLatestVersion = false;
                                });

                                if (isLatest) {
                                  UIService.showSnackbar(
                                      backgroundColor: theme.successColor,
                                      message: Tr.t("latestVersion"));
                                }
                              },
                            ),
                      Container(
                          margin: const EdgeInsets.all(5),
                          child: FutureBuilder(
                              future: PackageInfo.fromPlatform(),
                              builder: (context, snapshot) {
                                final packageInfo = snapshot.data;
                                String version = packageInfo?.version ?? "";
                                String buildNumber =
                                    packageInfo?.buildNumber ?? "";

                                return Text('v$version $buildNumber',
                                    style: const TextStyle(
                                        color: Color(0xFF65829A),
                                        fontSize: 10));
                              })),
                    ],
                  ),
                  const SizedBox(height: 24),
                  DefaultTabController(
                      length: 3,
                      child: Column(children: [
                        TabBar(
                          onTap: (index) async {
                            AnalyticsService.logEvent('about_tab_selected',
                                parameters: {'index': index.toString()});
                          },
                          tabs: [
                            Tab(child: Text(Tr.t("whoWeAre"))),
                            Tab(child: Text(Tr.t("ourBeliefs"))),
                            Tab(child: Text(Tr.t("staff")))
                          ],
                          unselectedLabelColor: theme.accentColor,
                        ),
                        SizedBox(
                            width: screenWidth,
                            height: orientation == Orientation.portrait
                                ? screenHeight * .55
                                : screenHeight * .4,
                            child: const TabBarView(children: [
                              WhoWeAreTab(),
                              OurBeliefsTab(),
                              StaffTab(),
                            ]))
                      ]))
                ])))));
  }
}
