import 'package:flutter/material.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/themes/light_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> aspirations = [
      "Centered in Christ",
      "Focused on evangelism",
      "Driven by disciple-making",
      "Suitable for community life to flourish",
      "Friendly to newcomers",
      "A place where believers grow in to maturity",
      "Broad in ministry, so that believers able to exercise their gift",
      "Live out the Gospel practically"
    ];

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(gradient: lightBackgroundGradient),
            child: SafeArea(
                child: Column(children: [
              Image.asset(AppImages.aboutLogo,
                  height: screenHeight * .3, width: screenWidth * .7),
              const SizedBox(height: 32),
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
                        height: screenHeight * .55,
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
                                        itemCount: aspirations.length,
                                        itemBuilder: (context, index) {
                                          final aspiration = aspirations[index];
                                          return ListTile(
                                              leading: const Icon(Icons.circle,
                                                  color: Colors.orange,
                                                  size: 14),
                                              title: Text(aspiration));
                                        })
                                  ]))),
                          Container(),
                          Container(),
                        ]))
                  ]))
            ]))));
  }
}
