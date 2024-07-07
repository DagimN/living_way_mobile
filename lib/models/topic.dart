class Topic {
  final String title;
  final int viewCount;
  final int likeCount;
  final bool isFavorite;
  final TopicType type;
  final String? backgroundImageUrl;

  Topic(
      {required this.title,
      required this.viewCount,
      required this.likeCount,
      this.backgroundImageUrl,
      this.isFavorite = false,
      this.type = TopicType.discussion});
}

enum TopicType { discussion, audio, video }
