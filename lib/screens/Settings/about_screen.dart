import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);
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
                    //TODO: Add 'Check for updates' button
                    const SizedBox(height: 24),
                    DefaultTabController(
                        length: 3,
                        child: Column(children: [
                          TabBar(tabs: [
                            Tab(child: Text(Tr.t("settings.whoWeAre"))),
                            Tab(child: Text(Tr.t("settings.ourBeliefs"))),
                            Tab(child: Text(Tr.t("settings.staff")))
                          ]),
                          SizedBox(
                              width: screenWidth,
                              height: orientation == Orientation.portrait
                                  ? screenHeight * .55
                                  : screenHeight * .4,
                              child: TabBarView(children: [
                                Container(
                                    margin: const EdgeInsets.all(24),
                                    child: SingleChildScrollView(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(Tr.t(
                                              'aboutPage.whoWeAreDescription1')),
                                          const SizedBox(height: 16),
                                          Text(Tr.t(
                                              'aboutPage.whoWeAreDescription2')),
                                          const SizedBox(height: 32),
                                          Text(Tr.t('aboutPage.aspireTitle'),
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w400)),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: contentController
                                                  .aspirations.length,
                                              itemBuilder: (context, index) {
                                                final aspiration =
                                                    contentController
                                                        .aspirations[index];
                                                return ListTile(
                                                    leading: const Icon(
                                                        Icons.circle,
                                                        color: Colors.orange,
                                                        size: 14),
                                                    title: Text(aspiration));
                                              })
                                        ]))),
                                Container(
                                    margin: const EdgeInsets.all(24),
                                    child: Text(Tr.t(
                                        'aboutPage.ourBeliefsDescription'))),
                                GridView.builder(
                                    padding: const EdgeInsets.only(bottom: 200),
                                    itemCount: contentController.staffs.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: orientation ==
                                                    Orientation.portrait
                                                ? 0.9
                                                : 1.5,
                                            crossAxisCount:
                                                screenWidth > 360 ? 3 : 2),
                                    itemBuilder: (context, index) {
                                      final staff =
                                          contentController.staffs[index];
                                      return Container(
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              gradient: AppTheme(themeController
                                                      .brightness)
                                                  .topicGradient,
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Column(children: [
                                            SizedBox(
                                                height: orientation ==
                                                        Orientation.portrait
                                                    ? screenHeight * .15
                                                    : screenHeight * .25,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: CachedNetworkImage(
                                                        imageUrl: staff.image,
                                                        memCacheHeight:
                                                            orientation ==
                                                                    Orientation
                                                                        .portrait
                                                                ? (screenHeight *
                                                                        .4)
                                                                    .toInt()
                                                                : (screenWidth *
                                                                        .4)
                                                                    .toInt(),
                                                        maxHeightDiskCache:
                                                            orientation ==
                                                                    Orientation
                                                                        .portrait
                                                                ? (screenHeight *
                                                                        .4)
                                                                    .toInt()
                                                                : (screenWidth *
                                                                        .4)
                                                                    .toInt(),
                                                        fit: BoxFit.cover))),
                                            const SizedBox(height: 10),
                                            Text(staff.name,
                                                style: TextStyle(
                                                    color: AppTheme(
                                                            themeController
                                                                .brightness)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14)),
                                            if (staff.position != null)
                                              Text(staff.position!,
                                                  style: TextStyle(
                                                      color: AppTheme(
                                                              themeController
                                                                  .brightness)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12))
                                          ]));
                                    })
                              ]))
                        ]))
                  ])))
            ]))));
  }
}
