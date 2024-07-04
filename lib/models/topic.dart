class Topic {
  final String title;
  final int viewCount;
  final int likeCount;
  final bool isFavorite;
  final TopicType type;

  Topic(
      {required this.title,
      required this.viewCount,
      required this.likeCount,
      this.isFavorite = false,
      this.type = TopicType.discussion});
}

enum TopicType { discussion, audio, video }
