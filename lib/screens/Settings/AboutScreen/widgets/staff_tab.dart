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
        position: 'Pastor',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FAdmas_9d5634fa95.jpg&w=1920&q=100"),
    Staff(
        name: 'Keneaa Zekarias',
        position: 'Pastor',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2F08_j1_9b017be72c.jpg&w=1920&q=100"),
    Staff(
        name: 'Henock Bekele',
        position: 'Pastor',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Fhenock_01_be02bb6828.jpg&w=1920&q=100"),
    Staff(
        name: 'Elias Seyoum',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Felias_seyoum_01_9b2c436491.jpg&w=1920&q=100"),
    Staff(
        name: 'Herani Sahlu',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FHerani_ac8d4aa110.jpg&w=1920&q=100"),
    Staff(
        name: 'Burakie Sahle',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FBurakae_7ad25f53fa.jpg&w=1920&q=100"),
    Staff(
        name: 'Halleluya Fikre',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FHalle_ce5a7ff718.jpg&w=1920&q=100"),
    Staff(
        name: 'Misikir Genene',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2FMesikir_068861e0d3.jpg&w=1920&q=100"),
    Staff(
        name: 'Henock Mesfin',
        image:
            "https://www.livingwayethiopia.org/_next/image?url=https%3A%2F%2Fcms.livingwayethiopia.org%2Fuploads%2Fhenock_misfin_01_37108eac59.jpg&w=1920&q=100")
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
            crossAxisCount: screenWidth > 360 ? 3 : 2),
        itemBuilder: (context, index) {
          final staff = staffs[index];
          return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  gradient: AppTheme(themeController.brightness).topicGradient,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(children: [
                SizedBox(
                    height: orientation == Orientation.portrait
                        ? screenHeight * .15
                        : screenHeight * .25,
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
                            fit: BoxFit.cover))),
                const SizedBox(height: 10),
                Text(staff.name,
                    style: TextStyle(
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
                if (staff.position != null)
                  Text(staff.position!,
                      style: TextStyle(
                          color:
                              AppTheme(themeController.brightness).primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12))
              ]));
        });
  }
}
