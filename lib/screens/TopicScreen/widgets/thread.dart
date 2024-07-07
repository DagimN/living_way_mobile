import 'package:flutter/material.dart';
import 'package:living_way/screens/TopicScreen/widgets/avatar_stack.dart';

class Thread extends StatelessWidget {
  final bool isLast;
  const Thread({super.key, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final threadKey = GlobalKey();

    return Container(
        key: threadKey,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarStack(threadKey: threadKey, participantCount: 5, isLast: isLast),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: screenWidth * .7,
                child: const Text(
                    'Lorem ipsum dolor sit, amet consectetur adipisicing elit. Libero dolores, veniam totam, molestias hic laboriosam dolorem minim')),
            Row(children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_alt_outlined)),
              const Text('5'),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment)),
              const Text('5')
            ])
          ])
        ]));
  }
}
