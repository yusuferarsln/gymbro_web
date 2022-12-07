import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/model/s_user_model.dart';
import 'package:gymbro_web/states/fetch_state.dart';

import '../services/api_service.dart';

final gymProvider = StateNotifierProvider<_GymNotifier, FetchState>(
  (ref) => _GymNotifier(),
);

class _GymNotifier extends StateNotifier<FetchState> {
  _GymNotifier() : super(Fetching()) {
    fetch();
  }
  void fetch() async {
    try {
      state = Fetching();
      final result = await api.getGyms();

      state = Fetched(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final gymAddProvider = StateNotifierProvider<_GymAddNotifier, FetchState>(
  (ref) => _GymAddNotifier(),
);

class _GymAddNotifier extends StateNotifier<FetchState> {
  _GymAddNotifier() : super(Fetching());
  void fetch(
      String gymAdress,
      String gymImage,
      int gymMemberCount,
      String gymName,
      String gymUser,
      String gymPassword,
      int gymToolCount) async {
    try {
      state = Fetching();
      final result = await api.addGym(gymAdress, gymImage, gymMemberCount,
          gymName, gymUser, gymPassword, gymToolCount);
      state = Fetched<bool>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final gymDeleteProvider = StateNotifierProvider<_GymDeleteNotifier, FetchState>(
  (ref) => _GymDeleteNotifier(),
);

class _GymDeleteNotifier extends StateNotifier<FetchState> {
  _GymDeleteNotifier() : super(Fetching());
  void fetch(int gymID) async {
    try {
      state = Fetching();
      final result = await api.deleteGym(gymID);
      state = Fetched<bool>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final getUsersProvider = StateNotifierProvider<_GetUserNotifier, FetchState>(
  (ref) => _GetUserNotifier(),
);

class _GetUserNotifier extends StateNotifier<FetchState> {
  _GetUserNotifier() : super(Fetching());
  void fetch(String email) async {
    try {
      state = Fetching();
      final result = await api.getSpecificUser(email);
      state = Fetched<List<SUserModel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final setAdminProvider = StateNotifierProvider<_SetAdminNotifier, FetchState>(
  (ref) => _SetAdminNotifier(),
);

class _SetAdminNotifier extends StateNotifier<FetchState> {
  _SetAdminNotifier() : super(Fetching());

  void setAdmin(int ID) async {
    try {
      state = Fetching();
      final result = await api.setAdmin(ID);

      state = Fetched<bool>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}
