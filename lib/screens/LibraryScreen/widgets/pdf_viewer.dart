import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:pdfrx/pdfrx.dart' as pdfrx;
import 'package:provider/provider.dart';

class PdfViewer extends StatefulWidget {
  final Content content;
  const PdfViewer({super.key, required this.content});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  final pdfController = pdfrx.PdfViewerController();

  pdfrx.PdfTextSearcher? searcher;

  bool isLoadingOutline = false;
  bool isOutlineLoaded = false;
  bool isPagedMode = true;
  List<pdfrx.PdfOutlineNode> outline = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    pdfController.addListener(pdfControllerListener);
  }

  void pdfControllerListener() async {
    if (pdfController.isReady && searcher == null) {
      setState(() {
        searcher = pdfrx.PdfTextSearcher(pdfController);
      });
    }

    if (pdfController.isReady && !isOutlineLoaded) {
      setState(() {
        isLoadingOutline = true;
      });

      final outline = await pdfController.document.loadOutline();

      setState(() {
        this.outline = outline;
        isLoadingOutline = false;
        isOutlineLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    pdfController.removeListener(pdfControllerListener);
    searcher?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: searcher?.pattern != null
            ? TextField(
                controller:
                    TextEditingController(text: searcher?.pattern.toString()),
                onSubmitted: (value) {
                  searcher?.startTextSearch(value);

                  Future.delayed(const Duration(milliseconds: 500), () {
                    setState(() {});
                  });
                })
            : Text(widget.content.title, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(isPagedMode ? Icons.import_contacts : Icons.list),
            onPressed: () => setState(() => isPagedMode = !isPagedMode),
          ),
          if (searcher?.pattern != null)
            IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  searcher?.resetTextSearch();
                  setState(() {});
                }),
          if (searcher != null && searcher?.pattern == null)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Search'),
                  content: TextField(
                    onSubmitted: (value) {
                      searcher?.startTextSearch(value, searchImmediately: true);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: (searcher?.pattern != null)
          ? Container(
              margin: const EdgeInsets.only(left: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme(themeController.brightness)
                      .secondaryButtonColor),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          searcher?.goToPrevMatch();
                          setState(() {});
                        }),
                    Text(
                        '${(searcher?.currentIndex ?? -1) + 1}/${searcher?.matches.length ?? 0}'),
                    IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          searcher?.goToNextMatch();
                          setState(() {});
                        }),
                  ]),
            )
          : null,
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: pdfrx.PdfViewer.file(
              widget.content.file?.path ?? "",
              controller: pdfController,
              params: pdfrx.PdfViewerParams(
                  layoutPages: (pages, params) {
                    final List<Rect> layouts = [];
                    double totalWidth = 0.0;
                    double totalHeight = 0.0;

                    if (isPagedMode) {
                      for (final page in pages) {
                        layouts.add(Rect.fromLTWH(
                            totalWidth, 0, page.width, page.height));
                        totalWidth += page.width;
                        if (page.height > totalHeight) {
                          totalHeight = page.height;
                        }
                      }
                    } else {
                      for (final page in pages) {
                        if (page.width > totalWidth) totalWidth = page.width;
                        layouts.add(Rect.fromLTWH(
                            0, totalHeight, page.width, page.height));
                        totalHeight += page.height;
                      }
                    }

                    return pdfrx.PdfPageLayout(
                      pageLayouts: layouts,
                      documentSize: Size(totalWidth, totalHeight),
                    );
                  },
                  pagePaintCallbacks: [
                    (canvas, size, page) {
                      searcher?.pageTextMatchPaintCallback(canvas, size, page);
                    },
                  ],
                  backgroundColor:
                      AppTheme(themeController.brightness).backgroundColor),
            ),
          ),
          if (themeController.brightness != Brightness.dark)
            IgnorePointer(
              child: Container(
                color: Colors.black
                    .withAlpha(100), //TODO: Add a slider to change the values
              ),
            ),
        ],
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
              SizedBox(height: screenHeight * .35),
              if (isLoadingOutline)
                const Center(child: CircularProgressIndicator()),
              if (!isLoadingOutline && outline.isEmpty)
                SizedBox(
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_rounded,
                            size: 48,
                            color: AppTheme(themeController.brightness)
                                .primaryColor),
                        const SizedBox(
                            width: 200,
                            child: Text('Table of contents is not available',
                                textAlign: TextAlign.center))
                      ]),
                ),
              if (!isLoadingOutline && outline.isNotEmpty)
                ListView(
                  children: outline
                      .map((node) => ListTile(
                            title: Text(node.title),
                            onTap: () => pdfController.goToDest(node.dest),
                          ))
                      .toList(),
                )
            ],
          ),
        ),
      ),
    );
  }
}
