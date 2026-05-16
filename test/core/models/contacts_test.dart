import 'package:flutter_test/flutter_test.dart';
import 'package:living_way/core/models/contacts.dart';

void main() {
  group('Contacts', () {
    test('constructor sets fields', () {
      final contacts = Contacts(
        title: 'Phone',
        addressList: ['+1234567890'],
        type: ContactType.phone,
      );
      expect(contacts.title, 'Phone');
      expect(contacts.addressList, ['+1234567890']);
      expect(contacts.type, ContactType.phone);
    });
  });

  group('ContactType', () {
    test('fromString returns correct type', () {
      expect(ContactType.fromString('phone'), ContactType.phone);
      expect(ContactType.fromString('email'), ContactType.email);
      expect(ContactType.fromString('location'), ContactType.location);
      expect(ContactType.fromString('social'), ContactType.social);
      expect(ContactType.fromString('unknown'), ContactType.undefined);
    });
  });
}
