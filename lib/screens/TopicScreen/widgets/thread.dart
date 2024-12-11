import 'package:flutter/material.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/controllers/profile_controller.dart';
import 'package:living_way/models/thread.dart';
import 'package:living_way/models/topic.dart';
import 'package:living_way/screens/TopicScreen/index.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:living_way/utils/shorten_number.dart';
import 'package:living_way/widgets/avatar_stack.dart';
import 'package:living_way/screens/TopicScreen/widgets/comment_box.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Thread extends StatefulWidget {
  final Topic topic;
  final ThreadData data;
  final bool hasSubThread;
  final bool isTop;
  final bool isLast;
  final ValueNotifier<GlobalKey<State<StatefulWidget>>?>? threadKeyNotifier;
  const Thread(
      {super.key,
      required this.topic,
      required this.data,
      this.threadKeyNotifier,
      this.hasSubThread = false,
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

    if (widget.threadKeyNotifier != null) {
      threadListener = () {
        if (widget.threadKeyNotifier?.value != threadKey && mounted) {
          setState(() {
            threadKey = GlobalKey();
          });
        }
      };

      widget.threadKeyNotifier?.addListener(threadListener);
    }
  }

  @override
  void dispose() {
    if (widget.threadKeyNotifier != null) {
      widget.threadKeyNotifier?.removeListener(threadListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    final userProfile = Provider.of<ProfileController>(context).userProfile;
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
              containerKey: threadKey,
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
                                      "_id": widget.topic.id,
                                      "viewCount": widget.topic.viewCount,
                                      "likeCount": widget.topic.likeCount,
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
            if (widget.topic.threads
                .any((thread) => thread.threadId == widget.data.threadId))
              isCommentBoxVisible
                  ? CommentBox(onSubmit: () async {
                      final comment = contentController
                          .commentBoxTextEditingController.text;
                      final topic = widget.topic;
                      final thread = widget.data;
                      final threadIndex = topic.threads.indexOf(widget.data);

                      if (userProfile != null) {
                        thread.subThreads.add(ThreadData(
                            threadId: const Uuid().v4(),
                            //TODO: Add thread flow field
                            commenter: userProfile.id,
                            comment: comment,
                            timestamp: DateTime.now()));
                        topic.threads.replaceRange(
                            threadIndex, threadIndex + 1, [thread]);

                        await contentController.updateTopic(topic);
                      }
                    }, onClose: () {
                      setState(() {
                        threadKey = GlobalKey();
                        contentController.setCommentingThreadKey = null;
                        contentController.commentBoxTextEditingController
                            .clear();
                      });
                    })
                  : Row(children: [
                      IconButton(
                          onPressed: () async {
                            if (userProfile != null) {
                              final topic = widget.topic;
                              final thread = widget.data;
                              final threadIndex =
                                  topic.threads.indexOf(widget.data);
                              if (!thread.likers
                                  .contains(userProfile.id)) {
                                thread.likers.add(userProfile.id);
                              } else {
                                thread.likers.remove(userProfile.id);
                              }

                              topic.threads.replaceRange(
                                  threadIndex, threadIndex + 1, [thread]);

                              await contentController.updateTopic(topic);
                              setState(() {});
                            }
                          },
                          icon: Icon(
                              widget.data.likers.contains(userProfile?.id)
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_alt_outlined,
                              color:
                                  widget.data.likers.contains(userProfile?.id)
                                      ? lightPrimaryColor
                                      : null)),
                      if (widget.data.likers.isNotEmpty)
                        Text(shortenNumber(widget.data.likers.length)),
                      if (!widget.hasSubThread)
                        IconButton(
                            onPressed: () {
                              setState(() {
                                threadKey = GlobalKey();
                                contentController.setCommentingThreadKey =
                                    threadKey;
                                contentController
                                    .commentBoxTextEditingController
                                    .clear();
                              });
                            },
                            icon: const Icon(Icons.comment)),
                      if (widget.data.subThreads.isNotEmpty)
                        Text(widget.data.subThreads.length.toString())
                    ])
            //TODO: Edit popup menu button for deleting, reporting
          ])
        ]));
  }
}
