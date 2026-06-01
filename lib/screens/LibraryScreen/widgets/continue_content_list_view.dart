import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

import 'pdf_viewer.dart';

class ContinueContentListView extends StatelessWidget {
  const ContinueContentListView({super.key});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final themeController = Provider.of<ThemeController>(context);
    final pausedContent = contentController.library
        .where((content) => content.contentRemaining != null)
        .toList();

    Orientation orientation = MediaQuery.of(context).orientation;
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    if (pausedContent.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.t('library.continueReading'),
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
          Container(
              height: orientation == Orientation.portrait
                  ? screenHeight * .1
                  : screenHeight * .2,
              width: screenWidth,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pausedContent.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final content = pausedContent[index];

                  return ListenableBuilder(
                      listenable: content,
                      builder: (context, child) {
                        DecorationImage? image;

                        if (content.thumbnailData != null) {
                          image = DecorationImage(
                              image: Image.memory(content.thumbnailData!,
                                      width: double.infinity,
                                      height: double.infinity)
                                  .image,
                              fit: BoxFit.cover);
                        }

                        return Container(
                          width: orientation == Orientation.portrait
                              ? screenWidth * .65
                              : screenWidth * .5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey),
                          ),
                          margin: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: () async {
                              AnalyticsService.logEvent('library_item_tapped',
                                  parameters: {
                                    'content_id': content.id,
                                    'title': content.title,
                                    'downloaded':
                                        content.file != null ? 'true' : 'false'
                                  });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PdfViewer(content: content)));
                            },
                            child: Row(spacing: 8, children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                    height: double.infinity,
                                    width: orientation == Orientation.portrait
                                        ? screenWidth * .15
                                        : screenWidth * .1,
                                    decoration: BoxDecoration(
                                        color:
                                            AppTheme(themeController.brightness)
                                                .primaryPanelColor,
                                        image: image),
                                    child: image == null
                                        ? Icon(Icons.book,
                                            color: AppTheme(
                                                    themeController.brightness)
                                                .primaryColor)
                                        : null),
                              ),
                              SizedBox(
                                width: orientation == Orientation.portrait
                                    ? screenWidth * .4
                                    : screenWidth * .35,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(content.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      Text(content.presenter,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400)),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        child: LinearProgressIndicator(
                                          value: content.contentRemaining ?? 0,
                                        ),
                                      )
                                    ]),
                              )
                            ]),
                          ),
                        );
                      });
                },
              )),
        ],
      ),
    );
  }
}
