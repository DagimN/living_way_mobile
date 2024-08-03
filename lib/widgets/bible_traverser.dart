import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/layout_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class BibleTraverser extends StatefulWidget {
  const BibleTraverser({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BibleTraverserState createState() => _BibleTraverserState();
}

class _BibleTraverserState extends State<BibleTraverser> {
  //TODO: Implement expanding animation for traversing buttons

  @override
  Widget build(BuildContext context) {
    final layoutController = Provider.of<LayoutController>(context);
    final contentController = Provider.of<ContentController>(context);
    final chapter = contentController.chapter ?? 0;
    final selectedBook =
        contentController.book ?? contentController.bible.firstOrNull;

    final isTraversing = layoutController.getSelectedHomePageNavigation ==
        HomePageNavigation.bible;
    final isFirst = chapter == 0;
    final isLast = chapter == (selectedBook?.chapters.length ?? 0) - 1;

    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            height: 48,
            width: isTraversing ? 144 : 48,
            decoration: BoxDecoration(
                color: lightPrimaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              if (isTraversing)
                IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      if (!isFirst) {
                        contentController.setChapter = chapter - 1;
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        size: 14, color: isFirst ? Colors.grey : Colors.white)),
              IconButton(
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    layoutController.setSelectedHomePageNavigation =
                        HomePageNavigation.bible;
                  },
                  icon: SvgPicture.asset(AppIcons.bible,
                      height: 20,
                      width: 20,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              if (isTraversing)
                IconButton(
                    style: IconButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      if (!isLast) {
                        contentController.setChapter = chapter + 1;
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded,
                        size: 14, color: isLast ? Colors.grey : Colors.white))
            ])));
  }
}
