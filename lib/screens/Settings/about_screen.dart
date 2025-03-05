import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/themes/app_theme.dart';
import 'package:living_way/themes/light_theme.dart';
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
                      icon: const Icon(Icons.arrow_back,
                          color: lightPrimaryColor))),
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
                          const TabBar(tabs: [
                            Tab(child: Text("Who We Are")),
                            Tab(child: Text("Our Beliefs")),
                            Tab(child: Text("Staff"))
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
                                          const Text(
                                              'We are a community of believers aspiring to be an authentic Christian community that glorifies Christ in both proclamation and lifestyle. Though we are not a gathering of perfect people, yet as a community, we believe that we are in the process of sanctification. This is why we strive to devote ourselves to studying Scripture, prayer, fellowship and the sharing of resources.'),
                                          const SizedBox(height: 16),
                                          const Text(
                                              'It is our conviction that the church is the steward of the message of the Good News, the only message of hope for fallen humanity. It is through this message that people can gain salvation and have access to a personal relationship with God. It is thus our mission to spread this Good News in every way possible and make peoples disciples of Christ.'),
                                          const SizedBox(height: 32),
                                          const Text(
                                              'We aspire to be a church that is: ',
                                              style: TextStyle(
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
                                    child: const Text(
                                        'In reprehenderit ea dolor in cillum est veniam aliqua esse cillum labore. Ut Lorem duis esse magna incididunt ea sunt dolor proident magna incididunt in. Cillum cupidatat aute occaecat non ad adipisicing minim nisi cupidatat aliquip nostrud pariatur dolor esse. Do nulla nulla duis amet mollit exercitation est laborum. Ut aliqua aliquip ea pariatur nulla reprehenderit culpa in. Excepteur nulla pariatur culpa non amet quis nulla. Quis dolore id enim voluptate laboris consequat cupidatat cupidatat anim Lorem. Enim labore laboris nulla ipsum culpa incididunt aliqua sit id pariatur non esse. Ad id magna elit esse irure laborum laboris do ex aute minim tempor. Aliquip veniam proident qui nulla. Sit voluptate culpa cillum reprehenderit do elit eiusmod reprehenderit ut qui in pariatur reprehenderit. Minim aliquip esse nostrud est commodo deserunt. Culpa duis sit sunt fugiat. Ullamco amet et tempor ut id.')),
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
                                              gradient: lightTopicGradient,
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
                                                style: const TextStyle(
                                                    color: lightPrimaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14)),
                                            if (staff.position != null)
                                              Text(staff.position!,
                                                  style: const TextStyle(
                                                      color: lightPrimaryColor,
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
