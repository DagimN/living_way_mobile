import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/controllers/notification_controller.dart';

void main() {
  group('NotificationController', () {
    test('can be instantiated', () {
      final controller = NotificationController();
      expect(controller, isA<NotificationController>());
    });

    test('notifies listeners when extended in future', () {
      final controller = NotificationController();
      var notified = false;
      controller.addListener(() => notified = true);
      controller.notifyListeners();
      expect(notified, isTrue);
    });
  });
}
