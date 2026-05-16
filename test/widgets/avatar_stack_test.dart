import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/widgets/avatar_stack.dart';

void main() {
  group('AvatarStack', () {
    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarStack(
              containerKey: GlobalKey(),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders avatars based on participant count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarStack(
              containerKey: GlobalKey(),
              participantCount: 3,
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsNWidgets(3));
    });

    testWidgets('caps avatars at 5 participants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarStack(
              containerKey: GlobalKey(),
              participantCount: 10,
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsNWidgets(5));
    });

    testWidgets('renders no avatars when count is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AvatarStack(
              containerKey: GlobalKey(),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsNothing);
    });
  });
}
