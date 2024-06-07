class Post {

  String? uid;
  int? age;
  String? username;
  String? faculty;

  Post({
    this.uid,
    this.age,
    this.username,
    this.faculty
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'age': age,
      'username': username,
      'faculty': faculty
    };
  }

  factory Post.fromJson(Map<String, dynamic> fromJson) {
    return Post(
      uid: fromJson['uid'],
      age: fromJson['age'],
      username: fromJson['username'],
      faculty: fromJson['faculty']
    );
  }
}