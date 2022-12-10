// ignore_for_file: public_member_api_docs, sort_constructors_first

class MUsermodel {
  User user;
  MUsermodel({
    required this.user,
  });

  factory MUsermodel.fromJson(Map<String, dynamic> map) {
    return MUsermodel(
      user: User.fromJson(map['user'] as Map<String, dynamic>),
    );
  }
}

class User {
  String user_email;
  String user_name;
  int id;
  User({required this.user_email, required this.user_name, required this.id});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      user_email: map['user_email'] as String,
      user_name: map['user_name'] as String,
      id: map['id'] as int,
    );
  }
}
