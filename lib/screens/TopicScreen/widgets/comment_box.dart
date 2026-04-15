import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class CommentBox extends StatelessWidget {
  final void Function() onSubmit;
  final void Function() onClose;
  const CommentBox({super.key, required this.onSubmit, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final devotionController = Provider.of<DevotionController>(context);
    final themeController = Provider.of<ThemeController>(context);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
        height: orientation == Orientation.portrait
            ? screenHeight * .18
            : screenWidth * .18,
        width: screenWidth * .7,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: AppTheme(themeController.brightness).primaryColor,
                width: 1),
            borderRadius: BorderRadius.circular(12)),
        child: Stack(children: [
          Column(children: [
            TextField(
                controller: devotionController.commentBoxTextEditingController,
                minLines: 3,
                maxLines: 3,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    hintText: "What's your opinion?",
                    border: InputBorder.none)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: () {
                        devotionController.commentBoxTextEditingController
                            .clear();
                      },
                      icon: const Icon(Icons.backspace_outlined,
                          color: Colors.red, size: 20)),
                  SizedBox(
                      width: orientation == Orientation.portrait
                          ? screenWidth * .2
                          : screenHeight * .2,
                      height: orientation == Orientation.portrait
                          ? screenHeight * .03
                          : screenWidth * .03,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor:
                                  AppTheme(themeController.brightness)
                                      .primaryColor),
                          onPressed: () {
                            onSubmit();
                            onClose();
                          },
                          child: const Text('Submit',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12))))
                ]))
          ]),
          Positioned(
              top: 5,
              right: 5,
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: IconButton(
                      style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: AppTheme(themeController.brightness)
                              .inactiveColor
                              .withAlpha(76)),
                      onPressed: onClose,
                      icon: Icon(Icons.close,
                          size: 16,
                          color: AppTheme(themeController.brightness)
                              .inactiveColor))))
        ]));
  }
}
