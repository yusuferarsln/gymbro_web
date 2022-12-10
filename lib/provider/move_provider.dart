import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/model/image_model.dart';
import 'package:gymbro_web/model/workout_model.dart';
import 'package:gymbro_web/states/fetch_state.dart';

import '../model/move_model.dart';
import '../services/api_service.dart';

final moveProvider =
    StateNotifierProvider.family<_MoveNotifier, FetchState, String>(
  (ref, area) => _MoveNotifier(area),
);

class _MoveNotifier extends StateNotifier<FetchState> {
  final String area;
  _MoveNotifier(this.area) : super(Fetching()) {
    fetch();
  }

  void fetch() async {
    try {
      state = Fetching();
      final result = await api.getMoves(area);
      state = Fetched<List<MoveModel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final workoutProvider = StateNotifierProvider<_WorkoutNotifier, FetchState>(
  (ref) => _WorkoutNotifier(),
);

class _WorkoutNotifier extends StateNotifier<FetchState> {
  _WorkoutNotifier() : super(Fetching()) {
    fetch();
  }

  void fetch() async {
    try {
      state = Fetching();
      final result = await api.getUserDetail();
      state = Fetched(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final getProgramProvider =
    StateNotifierProvider<_GetProgramNotifier, FetchState>(
  (ref) => _GetProgramNotifier(),
);

class _GetProgramNotifier extends StateNotifier<FetchState> {
  _GetProgramNotifier() : super(Fetching());

  void fetch(int gymID, int userID) async {
    try {
      state = Fetching();
      final result = await api.getWorkouts(gymID, userID);
      state = Fetched<List<WorkoutModel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final getImagesProvider = StateNotifierProvider<_GetImagesNotifier, FetchState>(
  (ref) => _GetImagesNotifier(),
);

class _GetImagesNotifier extends StateNotifier<FetchState> {
  _GetImagesNotifier() : super(Fetching());

  void fetch(int moveID) async {
    try {
      state = Fetching();
      final result = await api.getMoveImg(moveID);
      state = Fetched<List<ImageModel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}
