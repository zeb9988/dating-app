class User {
  final String userId;
  final String username;
  final List<Post> posts;

  User({
    required this.userId,
    required this.username,
    required this.posts,
  });
}

class Post {
  final String postId;
  final String content;
  final DateTime timestamp;

  Post({
    required this.postId,
    required this.content,
    required this.timestamp,
  });
}
