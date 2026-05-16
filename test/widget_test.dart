import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/themes/app_theme.dart';

void main() {
  testWidgets('App theme smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppTheme(Brightness.dark).primaryColor,
          ),
          useMaterial3: true,
        ),
        home: const Scaffold(
          body: Center(child: Text('Living Way')),
        ),
      ),
    );

    expect(find.text('Living Way'), findsOneWidget);
  });
}
