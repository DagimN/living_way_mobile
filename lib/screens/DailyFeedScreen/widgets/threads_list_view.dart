import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/screens/TopicScreen/widgets/thread.dart';
import 'package:provider/provider.dart';

class ThreadsListView extends StatelessWidget {
  final bool doesSubThreadExist;
  final Topic topic;
  final ThreadData? subThread;
  const ThreadsListView(
      {super.key,
      required this.topic,
      required this.doesSubThreadExist,
      this.subThread});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final themeController = Provider.of<ThemeController>(context);
    final contentController = Provider.of<ContentController>(context);
    final devotionController = Provider.of<DevotionController>(context);
    final threads = topic.threads;

    threads.sort((threadA, threadB) {
      if (contentController.threadActivityFilter == SortOptions.mostActive) {
        return (threadB.likers.length + threadB.subThreads.length) -
            (threadA.subThreads.length + threadA.likers.length);
      }

      if (contentController.threadActivityFilter == SortOptions.mostLiked) {
        return threadB.likers.length - threadA.likers.length;
      }

      if (contentController.threadActivityFilter == SortOptions.latest) {
        return threadB.timestamp.compareTo(threadA.timestamp);
      }

      return 0;
    });

    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Tr.t('home.threads'),
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppTheme(themeController.brightness)
                                .primaryColor)),
                    DropdownButton<SortOptions>(
                        items: [
                          DropdownMenuItem(
                              value: SortOptions.latest,
                              child: Text(Tr.t('home.sortLatest'))),
                          DropdownMenuItem(
                              value: SortOptions.mostActive,
                              child: Text(Tr.t('home.sortMostActive'))),
                          DropdownMenuItem(
                              value: SortOptions.mostLiked,
                              child: Text(Tr.t('home.sortMostLiked')))
                        ],
                        underline: Container(
                            height: 1.0,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            AppTheme(themeController.brightness)
                                                .primaryColor,
                                        width: 0.0)))),
                        style: TextStyle(
                            color: AppTheme(themeController.brightness)
                                .primaryColor),
                        value: contentController.threadActivityFilter,
                        onChanged: (value) {
                          contentController.setThreadFilter =
                              value ?? SortOptions.latest;
                        })
                  ])),
          SizedBox(
              height: screenHeight * .6,
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 300),
                  itemCount: threads.length + (doesSubThreadExist ? 1 : 0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return index == 0 && doesSubThreadExist
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: AppTheme(themeController.brightness)
                                    .inactiveColor
                                    .withAlpha(51),
                                borderRadius: BorderRadius.circular(10)),
                            child: Thread(
                                topic: topic,
                                isTop: true,
                                threadKeyNotifier: devotionController
                                    .commentingThreadKeyNotifier,
                                data: subThread!))
                        : Thread(
                            topic: topic,
                            threadKeyNotifier:
                                devotionController.commentingThreadKeyNotifier,
                            hasSubThread: doesSubThreadExist,
                            data: threads[index - (doesSubThreadExist ? 1 : 0)],
                            isLast: index ==
                                threads.length - (doesSubThreadExist ? 0 : 1));
                  }))
        ]));
  }
}
