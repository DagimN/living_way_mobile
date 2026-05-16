import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/theme_controller.dart';
import 'package:living_way/screens/Settings/ProfileSettingsScreen/widgets/setting_option_tile.dart';
import 'package:provider/provider.dart';
import '../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await initTestEnvironment();
  });

  group('SettingOptionTile', () {
    testWidgets('renders title and trailing widget', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MaterialApp(
            home: Scaffold(
              body: SettingOptionTile(
                title: 'Notifications',
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('shows loading indicator when updating', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: const MaterialApp(
            home: Scaffold(
              body: SettingOptionTile(
                title: 'Saving',
                trailing: Icon(Icons.save),
                isUpdating: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: MaterialApp(
            home: Scaffold(
              body: SettingOptionTile(
                title: 'Tap me',
                trailing: const Icon(Icons.edit),
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Tap me'));
      expect(tapped, isTrue);
    });
  });
}
