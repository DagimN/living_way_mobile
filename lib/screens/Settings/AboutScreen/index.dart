import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/Settings/AboutScreen/widgets/our_beliefs_tab.dart';
import 'package:living_way/screens/Settings/AboutScreen/widgets/staff_tab.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'widgets/who_we_are_tab.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: SafeArea(
                child: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,
                          color: AppTheme(themeController.brightness)
                              .primaryColor))),
              SizedBox(
                  height: orientation == Orientation.portrait
                      ? screenHeight * .85
                      : screenHeight * .75,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Image.asset(AppImages.aboutLogo,
                        height: orientation == Orientation.portrait
                            ? screenHeight * .3
                            : screenHeight * .4,
                        width: screenWidth * .7),
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
                                      color: Color(0xFF65829A), fontSize: 10));
                            })),
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
                                Tab(child: Text(Tr.t("settings.whoWeAre"))),
                                Tab(child: Text(Tr.t("settings.ourBeliefs"))),
                                Tab(child: Text(Tr.t("settings.staff")))
                              ]),
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
                  ])))
            ]))));
  }
}
