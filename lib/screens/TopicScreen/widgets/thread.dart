import 'package:flutter/material.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/screens/TopicScreen/widgets/avatar_stack.dart';
import 'package:living_way/screens/TopicScreen/widgets/comment_box.dart';

class Thread extends StatefulWidget {
  final ThreadData data;
  final bool isLast;
  const Thread({super.key, required this.data, this.isLast = false});

  @override
  State<Thread> createState() => _ThreadState();
}

class _ThreadState extends State<Thread> {
  bool isCommentBoxVisible = false;
  GlobalKey threadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
        key: threadKey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarStack(
              threadKey: threadKey,
              participantCount: widget.data.subThreads.length + 1,
              isLast: widget.isLast),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextButton(
                onPressed: widget.data.subThreads.isNotEmpty ? () {} : null,
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                child: SizedBox(
                    width: screenWidth * .65,
                    child: Text(widget.data.comment))),
            isCommentBoxVisible
                ? CommentBox(
                    onClose: () {
                      setState(() {
                        threadKey = GlobalKey();
                        isCommentBoxVisible = false;
                      });
                    },
                  )
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
