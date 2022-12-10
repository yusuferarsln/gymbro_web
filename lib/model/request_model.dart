// ignore_for_file: public_member_api_docs, sort_constructors_first

class RequestModel {
  int status;
  bool is_active;
  User user;
  RequestModel({
    required this.status,
    required this.is_active,
    required this.user,
  });

  factory RequestModel.fromJson(Map<String, dynamic> map) {
    return RequestModel(
      status: map['status'] as int,
      is_active: map['is_active'] as bool,
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
