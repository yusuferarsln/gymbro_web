// ignore_for_file: public_member_api_docs, sort_constructors_first

class WorkoutModel {
  List<Parts> workouts;
  WorkoutModel({
    required this.workouts,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> map) {
    return WorkoutModel(
      workouts: List<Parts>.from(
        (map['chest'] as List<dynamic>).map<Parts>(
          (x) => Parts.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class Parts {
  int id;
  String area;
  String name;
  int setc;
  int repeat;
  Parts({
    required this.id,
    required this.area,
    required this.name,
    required this.setc,
    required this.repeat,
  });

  factory Parts.fromJson(Map<String, dynamic> map) {
    return Parts(
      id: map['id'] as int,
      area: map['area'] as String,
      name: map['name'] as String,
      setc: map['setc'] as int,
      repeat: map['repeat'] as int,
    );
  }
}
