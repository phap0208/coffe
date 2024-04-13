// Comment class that contains all the data of the Comment. Format was inferred from
// https://jsonplaceholder.typicode.com/posts
class Post {
  late final int userId;
  late final int id;
  late final String title;
  late final String body;
  late final String songUrl;
  late final String lyrics;
  late final String artist;



  // Default contructor so that if we need to create Posts with specified values, we can.
  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });


  static List<Post> listFromJson(dynamic listJson) => listJson != null
      ? List<Post>.from(listJson.map((x) => Post.fromJson(x)))
      : [];
  // Constructor to create a Post object from JSON (Map from String to dynamic).
  Post.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }
}
