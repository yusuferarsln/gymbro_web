// ignore_for_file: public_member_api_docs, sort_constructors_first

class RecordedGymsModel {
  final String gymAddress;
  final String gymImage;
  final int gymMemberCount;
  final String gymName;
  final String gymPassword;
  final int gymToolCount;
  final String gymUser;
  final int id;
  final List<User>? users;
  RecordedGymsModel({
    required this.gymAddress,
    required this.gymImage,
    required this.gymMemberCount,
    required this.gymName,
    required this.gymPassword,
    required this.gymToolCount,
    required this.gymUser,
    required this.id,
    this.users,
  });

  RecordedGymsModel copyWith({
    String? gymAddress,
    String? gymImage,
    int? gymMemberCount,
    String? gymName,
    String? gymPassword,
    int? gymToolCount,
    String? gymUser,
    int? id,
    List<User>? users,
  }) {
    return RecordedGymsModel(
      gymAddress: gymAddress ?? this.gymAddress,
      gymImage: gymImage ?? this.gymImage,
      gymMemberCount: gymMemberCount ?? this.gymMemberCount,
      gymName: gymName ?? this.gymName,
      gymPassword: gymPassword ?? this.gymPassword,
      gymToolCount: gymToolCount ?? this.gymToolCount,
      gymUser: gymUser ?? this.gymUser,
      id: id ?? this.id,
      users: users ?? this.users,
    );
  }

  factory RecordedGymsModel.fromJson(Map<String, dynamic> map) {
    return RecordedGymsModel(
      gymAddress: map['gym_address'] as String,
      gymImage: map['gym_image'] as String,
      gymMemberCount: map['gym_member_count'] as int,
      gymName: map['gym_name'] as String,
      gymPassword: map['gym_password'] as String,
      gymToolCount: map['gym_tool_count'] as int,
      gymUser: map['gym_user'] as String,
      id: map['id'] as int,
      users: map['users'] != null
          ? List<User>.from(
              (map['users'] as List<dynamic>).map<User?>(
                (x) => User.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}

class User {
  final bool? is_gymbro_admin;
  final String? user_name;
  final String? user_email;
  final int? id;
  User({
    this.is_gymbro_admin,
    this.user_name,
    this.user_email,
    this.id,
  });

  User copyWith({
    bool? is_gymbro_admin,
    String? user_name,
    String? user_email,
    int? id,
  }) {
    return User(
      is_gymbro_admin: is_gymbro_admin ?? this.is_gymbro_admin,
      user_name: user_name ?? this.user_name,
      user_email: user_email ?? this.user_email,
      id: id ?? this.id,
    );
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      is_gymbro_admin: map['is_gymbro_admin'] != null
          ? map['is_gymbro_admin'] as bool
          : null,
      user_name: map['user_name'] != null ? map['user_name'] as String : null,
      user_email:
          map['user_email'] != null ? map['user_email'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }
}
