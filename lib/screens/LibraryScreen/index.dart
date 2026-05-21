import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'widgets/continue_content_list_view.dart';
import 'widgets/pdf_viewer.dart';
import 'widgets/content_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);
    final isFetching = contentController.isFetchingContents;
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
        book.downloadContent(context);
        contentController.saveLibrary(book);
        return;
      }

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PdfViewer(content: book)));
    }

    return RefreshIndicator(
      onRefresh: () {
        return contentController.fetchContents(isRefreshing: true);
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
            width: screenWidth,
            child: isFetching && contentController.library.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                        color:
                            AppTheme(themeController.brightness).primaryColor))
                : SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 50),
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: contentController.contentScrollController,
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
                                shrinkExtent:
                                    orientation == Orientation.portrait
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
                        if (popularBooks.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(),
                          ),
                        const ContinueContentListView(),
                        (otherContents.isEmpty)
                            ? Container(
                                width: orientation == Orientation.portrait
                                    ? screenWidth * .7
                                    : screenWidth * .3,
                                margin: orientation == Orientation.portrait &&
                                        popularBooks.isEmpty
                                    ? EdgeInsets.only(top: screenHeight * .15)
                                    : null,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ColorFiltered(
                                      colorFilter:
                                          const ColorFilter.matrix(<double>[
                                        0.35, 0.35, 0.35, 0,
                                        0, // Red: 35% intensity, no offset
                                        0.35, 0.35, 0.35, 0,
                                        0, // Green: 35% intensity, no offset
                                        0.35, 0.35, 0.35, 0,
                                        0, // Blue: 35% intensity, no offset
                                        0, 0, 0, 1, 0,
                                      ]),
                                      child: SvgPicture.asset(
                                        AppImages.emptyLibrary,
                                      ),
                                    ),
                                    Text(
                                      'No books available at the moment. Come back later',
                                      style: TextStyle(color: Colors.grey[500]),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              )
                            : MasonryGridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount:
                                    orientation == Orientation.portrait ? 2 : 3,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4,
                                itemCount: otherContents.length + 1,
                                itemBuilder: (context, index) {
                                  final content = otherContents.length > index
                                      ? otherContents[index]
                                      : Content.empty();

                                  return otherContents.length > index
                                      ? ContentCard(
                                          content: content,
                                          onTap: () => onBookTap(content),
                                        )
                                      : contentController.isFetchingContents
                                          ? AspectRatio(
                                              aspectRatio:
                                                  (content.width ?? 1) /
                                                      (content.height ?? 1),
                                              child: Shimmer.fromColors(
                                                  direction:
                                                      ShimmerDirection.rtl,
                                                  baseColor:
                                                      AppTheme(themeController.brightness)
                                                          .backgroundColor,
                                                  highlightColor:
                                                      AppTheme(themeController.brightness)
                                                          .primaryColor
                                                          .withAlpha(120),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: AppTheme(
                                                                  themeController.brightness)
                                                              .backgroundColor))),
                                            )
                                          : const SizedBox();
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
