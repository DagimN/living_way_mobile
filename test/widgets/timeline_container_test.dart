import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/core/models/activity.dart';
import 'package:living_way/widgets/timeline_container.dart';
import 'package:provider/provider.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('TimelineContainer', () {
    testWidgets('renders title and child content', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: MaterialApp(
            home: Scaffold(
              body: TimelineContainer(
                title: 'Sunday Service',
                timestamp: DateTime.now().subtract(const Duration(hours: 2)),
                type: ContentType.event,
                isOngoing: false,
                child: const Text('Event details'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sunday Service'), findsOneWidget);
      expect(find.text('Event details'), findsOneWidget);
    });

    testWidgets('shows Ongoing when isOngoing is true', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: MaterialApp(
            home: Scaffold(
              body: TimelineContainer(
                title: 'Live Stream',
                timestamp: DateTime.now(),
                type: ContentType.general,
                isOngoing: true,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Ongoing'), findsOneWidget);
    });
  });
}
