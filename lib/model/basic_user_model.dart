// ignore_for_file: public_member_api_docs, sort_constructors_first

class BasicUserModel {
  int id;
  String email;
  BasicUserModel({
    required this.id,
    required this.email,
  });

  BasicUserModel copyWith({
    int? id,
    String? email,
  }) {
    return BasicUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
    };
  }

  factory BasicUserModel.fromJson(Map<String, dynamic> map) {
    return BasicUserModel(
      id: map['id'] as int,
      email: map['user_email'] as String,
    );
  }
}
