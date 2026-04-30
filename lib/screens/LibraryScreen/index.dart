import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/continue_content_list_view.dart';
import 'widgets/pdf_viewer.dart';
import 'widgets/content_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);
    final popularBooks = contentController.library
        .where((content) => content.isPopular)
        .toList();
    final otherContents = contentController.library
        .where((content) => !content.isPopular)
        .toList();

    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    Orientation orientation = MediaQuery.of(context).orientation;

    void onBookTap(Content book) {
      if (book.isDownloading) return;

      if (book.file == null) {
        book.downloadContent();
        contentController.saveLibrary(book);
        return;
      }

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PdfViewer(content: book)));
    }

    return RefreshIndicator(
      onRefresh: () {
        //TODO: Implement refresh logic
        return Future.delayed(const Duration(seconds: 1));
      },
      child: Container(
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
                ? screenHeight * .78
                : screenHeight * .45,
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                children: [
                  if (popularBooks.isNotEmpty)
                    Container(
                      //TODO: Implement paid content feature
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
                          onTap: (index) {
                            final book = popularBooks[index];

                            onBookTap(book);
                          },
                          children: popularBooks
                              .map((book) => ContentCard(content: book))
                              .toList()),
                    ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(),
                  ),
                  const ContinueContentListView(),
                  MasonryGridView.count(
                    //TODO: Add placeholder image when library is empty
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: otherContents.length,
                    itemBuilder: (context, index) {
                      final content = otherContents[index];

                      return ContentCard(
                        content: content,
                        onTap: () => onBookTap(content),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
