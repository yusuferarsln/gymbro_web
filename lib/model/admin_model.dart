// ignore_for_file: public_member_api_docs, sort_constructors_first

class AdminModel {
  int id;
  String email;
  AdminModel({
    required this.id,
    required this.email,
  });

  AdminModel copyWith({
    int? id,
    String? email,
  }) {
    return AdminModel(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  factory AdminModel.fromJson(Map<String, dynamic> map) {
    return AdminModel(
      id: map['id'] as int,
      email: map['user_email'] as String,
    );
  }
}
