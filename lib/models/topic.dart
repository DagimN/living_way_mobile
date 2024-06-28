class Topic {
  final String title;
  final int viewCount;
  final bool isFavorite;
  final TopicType type;

  Topic(
      {required this.title,
      required this.viewCount,
      this.isFavorite = false,
      this.type = TopicType.discussion});
}

enum TopicType { discussion, audio, video }
