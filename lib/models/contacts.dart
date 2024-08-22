class Contacts {
  final String title;
  final List<String> addressList;
  final ContactType type;

  Contacts(
      {required this.title, required this.addressList, required this.type});
}

enum ContactType {
  phone,
  email,
  location,
  social,
  undefined;

  static ContactType fromString(String value) {
    switch (value) {
      case 'phone':
        return ContactType.phone;
      case 'email':
        return ContactType.email;
      case 'location':
        return ContactType.location;
      case 'social':
        return ContactType.social;
      default:
        return ContactType.undefined;
    }
  }
}
