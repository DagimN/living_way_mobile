class MediaMetadata {
  String title;
  String presenter;
  //String duration;
  String source;

  MediaMetadata(
      {required this.title, required this.presenter, required this.source});

  static MediaMetadata fromJson(json) {
    return MediaMetadata(
        title: json['title'],
        presenter: json['presenter'],
        source: json['source']);
  }

  toJson() {
    return {"title": title, "presenter": presenter, "source": source};
  }
}
