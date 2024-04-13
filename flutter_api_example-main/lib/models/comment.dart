// Comment class that contains all the data of the Comment. Format was inferred from
// https://jsonplaceholder.typicode.com/comments?postId=1
class Comment {
  late final int postId;
  late final int id;
  late final String name;
  late final String email;
  late final String body;

  // Default contructor so that if we need to create Comments with specified values, we can.
  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  // Constructor to create a Comment object from JSON (Map from String to dynamic).
  Comment.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    body = json['body'];
  }
}
