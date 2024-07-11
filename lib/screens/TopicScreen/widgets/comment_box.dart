import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class CommentBox extends StatelessWidget {
  final void Function() onClose;
  const CommentBox({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        height: screenHeight * .18,
        width: screenWidth * .7,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: lightPrimaryColor, width: 1),
            borderRadius: BorderRadius.circular(12)),
        child: Stack(children: [
          Column(children: [
            TextField(
                controller: contentController.commentBoxTextEditingController,
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
                        contentController.commentBoxTextEditingController
                            .clear();
                      },
                      icon: const Icon(Icons.backspace_outlined,
                          color: Colors.red, size: 20)),
                  SizedBox(
                      width: screenWidth * .2,
                      height: screenHeight * .03,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: lightPrimaryColor),
                          onPressed: () {
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
                          backgroundColor: lightInactiveColor.withOpacity(.3)),
                      onPressed: onClose,
                      icon: const Icon(Icons.close,
                          size: 16, color: lightInactiveColor))))
        ]));
  }
}
