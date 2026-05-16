import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/extensions/string.dart';

void main() {
  group('StringExtension.capitalize', () {
    test('capitalizes first letter', () {
      expect('hello'.capitalize(), 'Hello');
      expect('World'.capitalize(), 'World');
    });

    test('handles single character', () {
      expect('a'.capitalize(), 'A');
    });
  });
}
