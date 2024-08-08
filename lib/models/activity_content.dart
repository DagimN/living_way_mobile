class ActivityContent {
  final String? title;
  final String? body;
  final List<String> images;
  final ContentType type;
  final DateTime timestamp;
  final String? externalLink;
  final Banner? banner;

  ActivityContent(
      {this.title,
      this.body,
      this.images = const [],
      this.externalLink,
      this.banner,
      required this.type,
      required this.timestamp});
}

class Banner {
  String url;
  String position;

  Banner({required this.position, required this.url});
}

enum ContentType {
  gallery,
  poll,
  article,
  external,
}
