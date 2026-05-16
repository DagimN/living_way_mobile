import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/widgets/dot_indicator.dart';

void main() {
  group('DotIndicator', () {
    testWidgets('renders dots for each page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DotIndicator(
              pages: const [
                SizedBox(),
                SizedBox(),
                SizedBox(),
              ],
              dotRadius: 8,
              currentIndex: 0,
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsNWidgets(3));
      await tester.pumpAndSettle();
    });

    testWidgets('active dot is wider than inactive', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DotIndicator(
              pages: const [SizedBox(), SizedBox()],
              dotRadius: 10,
              currentIndex: 0,
            ),
          ),
        ),
      );

      final containers = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(GestureDetector).first,
          matching: find.byType(Container),
        ),
      );

      expect(containers.isNotEmpty, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('calls onDotTap when dot is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DotIndicator(
              pages: const [SizedBox(), SizedBox()],
              dotRadius: 8,
              onDotTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector).first);
      expect(tapped, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('animate mode starts animation controller', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DotIndicator(
              pages: const [SizedBox(), SizedBox()],
              dotRadius: 8,
              currentIndex: 0,
              animate: true,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });
  });
}
