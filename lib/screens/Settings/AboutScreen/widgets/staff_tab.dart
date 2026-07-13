import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class StaffTab extends StatelessWidget {
  const StaffTab({super.key});

  static List<Staff> staffs = [
    Staff(
        name: 'Admas Getachew',
        position: 'pastor',
        image: "https://livingwaytest.netlify.app/image/Elders/Admas.webp"),
    Staff(
        name: 'Keneaa Zekarias',
        position: 'pastor',
        image: "https://livingwaytest.netlify.app/image/Elders/Keneaa.webp"),
    Staff(
        name: 'Henock Bekele',
        position: 'pastor',
        image: "https://livingwaytest.netlify.app/image/Elders/Henock.webp"),
    Staff(
      name: 'Misikir Genene',
      image: "https://livingwaytest.netlify.app/image/Elders/Misikir.webp",
      position: 'churchElder',
    ),
    Staff(
        name: 'Burakie Sahle',
        image: "https://livingwaytest.netlify.app/image/Elders/Burakie.webp",
        position: 'churchElder'),
    Staff(
        name: 'Esisha Mengistu',
        image: "https://livingwaytest.netlify.app/image/Elders/Esisha.webp",
        position: 'churchElder'),
    Staff(
        name: 'Fasil Negash',
        image: "https://livingwaytest.netlify.app/image/Elders/Fasil.webp",
        position: 'churchElder'),
    Staff(
        name: 'Yared Donis',
        image: "https://livingwaytest.netlify.app/image/Elders/Yared.webp",
        position: 'churchElder'),
    Staff(
        name: 'Minase Eliyas',
        image: "https://livingwaytest.netlify.app/image/Elders/Minase.webp",
        position: 'churchElder'),
    Staff(
        name: 'Dagem Daniel',
        image: "https://livingwaytest.netlify.app/image/Elders/Dagim.webp",
        position: 'churchElder'),
  ];

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return GridView.builder(
        padding: const EdgeInsets.only(bottom: 200),
        itemCount: staffs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: orientation == Orientation.portrait ? 0.9 : 1.5,
            crossAxisCount: screenWidth > 420 ? 3 : 2),
        itemBuilder: (context, index) {
          final staff = staffs[index];
          return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  gradient: AppTheme(themeController.brightness).topicGradient,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                Expanded(
                  child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            imageUrl: staff.image,
                            memCacheHeight: orientation == Orientation.portrait
                                ? (screenHeight * .4).toInt()
                                : (screenWidth * .4).toInt(),
                            maxHeightDiskCache:
                                orientation == Orientation.portrait
                                    ? (screenHeight * .4).toInt()
                                    : (screenWidth * .4).toInt(),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ))),
                ),
                const SizedBox(height: 10),
                Text(staff.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
                if (staff.position != null)
                  Text(Tr.t(staff.position ?? ""),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color:
                              AppTheme(themeController.brightness).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12))
              ]));
        });
  }
}
