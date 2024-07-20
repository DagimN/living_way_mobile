import 'package:flutter/material.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/TopicScreen/index.dart';
import 'package:living_way/screens/TopicScreen/widgets/avatar_stack.dart';
import 'package:living_way/screens/TopicScreen/widgets/comment_box.dart';

class Thread extends StatefulWidget {
  final Topic topic;
  final ThreadData data;
  final bool isTop;
  final bool isLast;
  const Thread(
      {super.key,
      required this.topic,
      required this.data,
      this.isTop = false,
      this.isLast = false});

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  bool isCommentBoxVisible = false;
  GlobalKey threadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
        key: threadKey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarStack(
              threadKey: threadKey,
              participantCount:
                  !widget.isTop ? widget.data.subThreads.length + 1 : 1,
              isLast: widget.isLast),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextButton(
                onPressed: widget.data.subThreads.isNotEmpty && !widget.isTop
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TopicScreen(
                                    topic: Topic.fromJson({
                                      ...widget.topic.toJson(),
                                      "threads": widget.data.subThreads
                                          .map((thread) => thread.toJson())
                                          .toList()
                                    }),
                                    subThread: widget.data)));
                      }
                    : null,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: SizedBox(
                    width: orientation == Orientation.portrait
                        ? screenWidth * .65
                        : screenHeight * .65,
                    child: Text(widget.data.comment))),
            isCommentBoxVisible //FIXME: When another comment box is opened close any other that has been opened
                ? CommentBox(onClose: () {
                    setState(() {
                      threadKey = GlobalKey();
                      isCommentBoxVisible = false;
                    });
                  })
                : Row(children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up_alt_outlined)),
                    if (widget.data.likes > 0)
                      Text(widget.data.likes.toString()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            threadKey = GlobalKey();
                            isCommentBoxVisible = true;
                          });
                        },
                        icon: const Icon(Icons.comment)),
                    if (widget.data.subThreads.isNotEmpty)
                      Text(widget.data.subThreads.length.toString())
                  ])
          ])
        ]));
  }
}
