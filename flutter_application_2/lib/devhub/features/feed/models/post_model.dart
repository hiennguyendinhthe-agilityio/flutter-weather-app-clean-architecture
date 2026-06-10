class Post {
  final String id;
  final String authorName;
  final String title;
  final String excerpt;
  final List<String> tags;
  final int likesCount;
  final int commentsCount;

  const Post({
    required this.id,
    required this.authorName,
    required this.title,
    required this.excerpt,
    required this.tags,
    required this.likesCount,
    required this.commentsCount,
  });
}
