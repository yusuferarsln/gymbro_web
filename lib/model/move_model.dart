// ignore_for_file: public_member_api_docs, sort_constructors_first

class MoveModel {
  final int id;
  final String moveName;
  final String moveArea;
  MoveModel({
    required this.id,
    required this.moveName,
    required this.moveArea,
  });

  MoveModel copyWith({
    int? id,
    String? moveName,
    String? moveArea,
  }) {
    return MoveModel(
      id: id ?? this.id,
      moveName: moveName ?? this.moveName,
      moveArea: moveArea ?? this.moveArea,
    );
  }

  factory MoveModel.fromJson(Map<String, dynamic> map) {
    return MoveModel(
      id: map['id'] as int,
      moveName: map['move_name'] as String,
      moveArea: map['move_area'] as String,
    );
  }
}
