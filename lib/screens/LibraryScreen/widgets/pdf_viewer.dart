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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  pdfrx.PdfTextSearcher? searcher;

  bool isLoadingOutline = false;
  bool isOutlineLoaded = false;
  bool isPagedMode = false;
  bool isTraversing = false;
  List<pdfrx.PdfOutlineNode> outline = [];
  int blackTintOpacity = 0;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    pdfController.addListener(pdfControllerListener);
  }

  void initializeSearcher() {
    if (pdfController.isReady && searcher == null) {
      setState(() {
        searcher = pdfrx.PdfTextSearcher(pdfController);
      });
    }
  }

  void loadOutline() async {
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

  void updateCurrentPageIndex() {
    final int newPage = pdfController.pageNumber ?? 0;

    if (newPage != currentPageIndex && !isTraversing) {
      setState(() {
        currentPageIndex = newPage;
      });
    }
  }

  void pdfControllerListener() {
    if (pdfController.isReady && widget.content.previouslyLeftOn != null) {
      pdfController.goToPage(pageNumber: widget.content.previouslyLeftOn ?? 0);

      if (pdfController.pageNumber == widget.content.previouslyLeftOn) {
        widget.content.previouslyLeftOn = null;
      }
    }

    initializeSearcher();
    loadOutline();
    updateCurrentPageIndex();
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
    final contentController = Provider.of<ContentController>(context);

    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        contentController.saveLibrary(widget.content,
            pdfController: pdfController);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: searcher?.pattern != null
              ? TextField(
                  controller:
                      TextEditingController(text: searcher?.pattern.toString()),
                  onSubmitted: (value) async {
                    searcher?.startTextSearch(value);
                    AnalyticsService.logEvent('pdf_text_search', parameters: {
                      'content_id': widget.content.id,
                      'search_pattern': value,
                    });

                    Future.delayed(const Duration(milliseconds: 500), () {
                      setState(() {});
                    });
                  })
              : Text(widget.content.title,
                  style: const TextStyle(fontSize: 16)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          actions: [
            //TODO: Give option for saving non-paid content to the external storage
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
                    content: TextField(
                      textInputAction: TextInputAction.search,
                      decoration:
                          InputDecoration(hintText: Tr.t('library.search')),
                      onSubmitted: (value) async {
                        searcher?.startTextSearch(value,
                            searchImmediately: true);
                        AnalyticsService.logEvent('pdf_text_search',
                            parameters: {
                              'content_id': widget.content.id,
                              'search_pattern': value,
                            });
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
                        searcher?.pageTextMatchPaintCallback(
                            canvas, size, page);
                      },
                    ],
                    backgroundColor:
                        AppTheme(themeController.brightness).backgroundColor),
              ),
            ),
            IgnorePointer(
              child: Container(
                color: Colors.black.withAlpha(blackTintOpacity),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: (isLoadingOutline)
              ? const Center(child: CircularProgressIndicator())
              : (!isLoadingOutline && outline.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Icon(Icons.book_rounded,
                              size: 48,
                              color: AppTheme(themeController.brightness)
                                  .primaryColor),
                          SizedBox(
                              width: 200,
                              child: Text(
                                  Tr.t('library.tableOfContentsUnavailable'),
                                  textAlign: TextAlign.center)),
                        ])
                  : ListView(
                      children: outline
                          .map((node) => ListTile(
                                title: Text(node.title),
                                onTap: () {
                                  pdfController.goToDest(node.dest);
                                  Navigator.pop(context);
                                },
                              ))
                          .toList(),
                    ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.view_list)),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      elevation: 0,
                      barrierColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          StatefulBuilder(builder: (context, setModalState) {
                            return Container(
                              height: 50,
                              margin: EdgeInsets.fromLTRB(
                                  20, 0, 20, screenHeight * .12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme(themeController.brightness)
                                      .secondaryButtonColor),
                              child: Slider(
                                  value: currentPageIndex.toDouble(),
                                  min: 1,
                                  max: pdfController.pageCount.toDouble(),
                                  onChanged: (value) async {
                                    setState(() {
                                      isTraversing = true;
                                      currentPageIndex = value.toInt();
                                    });

                                    await pdfController.goToPage(
                                        pageNumber: value.toInt());

                                    setState(() {
                                      isTraversing = false;
                                    });
                                    setModalState(() {});
                                  }),
                            );
                          }));
                },
                child: Text(pdfController.isReady
                    ? '$currentPageIndex/${pdfController.pageCount}'
                    : '0'),
              ),
              IconButton(
                icon: Icon(isPagedMode ? Icons.import_contacts : Icons.list),
                onPressed: () => setState(() => isPagedMode = !isPagedMode),
              ),
              IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        elevation: 0,
                        barrierColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setModalState) {
                              return Container(
                                height: 50,
                                margin: EdgeInsets.fromLTRB(
                                    20, 0, 20, screenHeight * .12),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppTheme(themeController.brightness)
                                        .secondaryButtonColor),
                                child: Slider(
                                    value: blackTintOpacity.toDouble(),
                                    min: 0,
                                    max: 100,
                                    onChanged: (value) {
                                      setState(() =>
                                          blackTintOpacity = value.toInt());
                                      setModalState(() {});
                                    }),
                              );
                            }));
                  }),
            ])),
      ),
    );
  }
}
