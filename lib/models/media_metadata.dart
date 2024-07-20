class MediaMetadata {
  String title;
  String presenter;
  //String duration;
  String videoId;

  MediaMetadata(
      {required this.title, required this.presenter, required this.videoId});

  static MediaMetadata fromJson(json) {
    return MediaMetadata(
        title: json['title'],
        presenter: json['presenter'],
        videoId: json['videoId']);
  }

  toJson() {
    return {"title": title, "presenter": presenter, "videoId": videoId};
  }
}
