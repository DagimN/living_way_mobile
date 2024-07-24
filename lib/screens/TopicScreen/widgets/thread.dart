import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/TopicScreen/index.dart';
import 'package:living_way/screens/TopicScreen/widgets/avatar_stack.dart';
import 'package:living_way/screens/TopicScreen/widgets/comment_box.dart';
import 'package:provider/provider.dart';

class Thread extends StatefulWidget {
  final Topic topic;
  final ThreadData data;
  final bool isTop;
  final bool isLast;
  final ValueNotifier<GlobalKey<State<StatefulWidget>>?> threadKeyNotifier;
  const Thread(
      {super.key,
      required this.topic,
      required this.data,
      required this.threadKeyNotifier,
      this.isTop = false,
      this.isLast = false});

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  GlobalKey threadKey = GlobalKey();
  void Function() threadListener = () {};

  @override
  void initState() {
    super.initState();

    threadListener = () {
      if (widget.threadKeyNotifier.value != threadKey && mounted) {
        setState(() {
          threadKey = GlobalKey();
        });
      }
    };

    widget.threadKeyNotifier.addListener(threadListener);
  }

  @override
  void dispose() {
    widget.threadKeyNotifier.removeListener(threadListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isCommentBoxVisible =
        contentController.commentingThreadKeyNotifier.value == threadKey;

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
                        contentController.setCommentingThreadKey = null;
                        contentController.commentBoxTextEditingController
                            .clear();
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
            isCommentBoxVisible
                ? CommentBox(onClose: () {
                    setState(() {
                      threadKey = GlobalKey();
                      contentController.setCommentingThreadKey = null;
                      contentController.commentBoxTextEditingController.clear();
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
                            contentController.setCommentingThreadKey =
                                threadKey;
                            contentController.commentBoxTextEditingController
                                .clear();
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
