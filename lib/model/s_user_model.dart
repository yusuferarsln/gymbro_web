// ignore_for_file: public_member_api_docs, sort_constructors_first

class SUserModel {
  int id;
  String email;
  SUserModel({
    required this.id,
    required this.email,
  });

  SUserModel copyWith({
    int? id,
    String? email,
  }) {
    return SUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  factory SUserModel.fromJson(Map<String, dynamic> map) {
    return SUserModel(
      id: map['id'] as int,
      email: map['user_email'] as String,
    );
  }
}
