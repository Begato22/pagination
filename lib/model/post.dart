class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: (json['title'] as String)[0].toUpperCase() + (json['title'] as String).substring(1),
      body: (json['body'] as String)[0].toUpperCase() + (json['body'] as String).substring(1),
    );
  }
}
