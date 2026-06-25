import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class GiveScreen extends StatelessWidget {
  const GiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final transactionController = Provider.of<TransactionController>(context);
    final bankAccounts = transactionController.bankAccounts;

    Orientation orientation = MediaQuery.of(context).orientation;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
                gradient:
                    AppTheme(themeController.brightness).backgroundGradient),
            child: SafeArea(
                child: RefreshIndicator(
              onRefresh: transactionController.fetchAccounts,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back,
                                color: AppTheme(themeController.brightness)
                                    .primaryColor)),
                        Text(Tr.t('settings.give'),
                            style: TextStyle(
                                fontSize: 32,
                                color: AppTheme(themeController.brightness)
                                    .primaryColor,
                                fontWeight: FontWeight.w300))
                      ])),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 200),
                      itemCount: bankAccounts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              orientation == Orientation.portrait ? 0.7 : 1.2,
                          crossAxisCount: screenWidth > 360 ? 3 : 2),
                      itemBuilder: (context, index) {
                        final bank = bankAccounts[index];

                        return Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                gradient: AppTheme(themeController.brightness)
                                    .topicGradient,
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      (bank.isMain)
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(Icons.star,
                                                  color: AppTheme(
                                                          themeController
                                                              .brightness)
                                                      .primaryColor),
                                            )
                                          : const SizedBox(),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.open_in_new,
                                            size: 16),
                                        onPressed: () async {
                                          await Clipboard.setData(ClipboardData(
                                              text: bank.account));
                                          final isLaunched =
                                              await transactionController
                                                  .openBankApp(bank.scheme);

                                          if (!isLaunched) {
                                            UIService.showSnackbar(
                                                backgroundColor: AppTheme(
                                                        themeController
                                                            .brightness)
                                                    .failedColor,
                                                message: Tr.arg(
                                                    'failedAppLaunch',
                                                    bank.name));
                                            return;
                                          }

                                          AnalyticsService.logEvent(
                                              'bank_app_launched',
                                              parameters: {
                                                "bank": bank.name,
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          orientation == Orientation.portrait
                                              ? screenHeight * .15
                                              : screenHeight * .25,
                                      width: orientation == Orientation.portrait
                                          ? screenHeight * .15
                                          : screenHeight * .25,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: CachedNetworkImage(
                                            imageUrl: bank.logo,
                                            memCacheHeight: orientation ==
                                                    Orientation.portrait
                                                ? (screenHeight * .4).toInt()
                                                : (screenWidth * .4).toInt(),
                                            maxHeightDiskCache: orientation ==
                                                    Orientation.portrait
                                                ? (screenHeight * .4).toInt()
                                                : (screenWidth * .4).toInt(),
                                          ))),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        Text(bank.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: AppTheme(themeController
                                                        .brightness)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14)),
                                        InkWell(
                                          onTap: () async {
                                            await Clipboard.setData(
                                                ClipboardData(
                                                    text: bank.account));
                                            AnalyticsService.logEvent(
                                                'bank_account_copied',
                                                parameters: {
                                                  "bank": bank.name,
                                                });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            spacing: 4,
                                            children: [
                                              Text(bank.account,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: AppTheme(
                                                              themeController
                                                                  .brightness)
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12)),
                                              const Icon(Icons.copy, size: 12),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ]));
                      })
                ]),
              ),
            ))));
  }
}
