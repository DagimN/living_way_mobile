import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/continue_content_list_view.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);
    final libraryItems = contentController.libraryItems;

    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(children: [
        BaseAppBar(
            title: Container(
                margin: const EdgeInsets.all(10),
                child: Text('Library',
                    style: TextStyle(
                        fontSize: 32,
                        color:
                            AppTheme(themeController.brightness).primaryColor,
                        fontWeight: FontWeight.w300))),
            actions: const [SearchButton()]),
        SizedBox(
          height: orientation == Orientation.portrait
              ? screenHeight * .76
              : screenHeight * .45,
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              children: [
                Container(
                  height: orientation == Orientation.portrait
                      ? screenHeight * .3
                      : screenHeight * .7,
                  width: screenWidth,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CarouselView(
                    itemExtent: orientation == Orientation.portrait
                        ? screenWidth * .45
                        : screenWidth * .3,
                    shrinkExtent: orientation == Orientation.portrait
                        ? screenWidth * .4
                        : screenWidth * .25,
                    backgroundColor: Colors.transparent,
                    itemSnapping: true,
                    children: List.generate(10, (int index) {
                      return Container(
                        color: Colors.amber,
                        child: Center(child: Text('Update $index')),
                      );
                    }),
                  ),
                ),
                const ContinueContentListView(),
                MasonryGridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: libraryItems.length,
                  itemBuilder: (context, index) {
                    final item = libraryItems[index];

                    return AspectRatio(
                      aspectRatio: item,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: const Icon(Icons.article_rounded,
                              color: Color(0xFFFFFBDC))),
                    );
                  },
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
