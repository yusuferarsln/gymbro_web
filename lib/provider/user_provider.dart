import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/model/m_user_model.dart';
import 'package:gymbro_web/model/request_model.dart';

import '../model/basic_user_model.dart';
import '../services/api_service.dart';
import '../states/fetch_state.dart';

final userProvider = StateNotifierProvider<_UserNotifier, FetchState>(
  (ref) => _UserNotifier(),
);

class _UserNotifier extends StateNotifier<FetchState> {
  _UserNotifier() : super(Fetching()) {
    fetch();
  }

  void fetch() async {
    try {
      state = Fetching();
      final result = await api.getUserDetail();
      state = Fetched<List<BasicUserModel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final gymIDProvider = StateNotifierProvider<_GymIDNotifier, FetchState>(
  (ref) => _GymIDNotifier(),
);

class _GymIDNotifier extends StateNotifier<FetchState> {
  _GymIDNotifier() : super(Fetching());

  void fetch(int userID) async {
    try {
      state = Fetching();
      final result = await api.getGymID(userID);
      state = Fetched<int>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final memberRequestProvider =
    StateNotifierProvider<_MemberRequestNotifier, FetchState>(
  (ref) => _MemberRequestNotifier(),
);

class _MemberRequestNotifier extends StateNotifier<FetchState> {
  _MemberRequestNotifier() : super(Fetching());

  fetch(int gymID) async {
    try {
      state = Fetching();
      final result = await api.getRequests(gymID);
      state = Fetched<List<RequestModel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}

final membersProvider = StateNotifierProvider<_MemberNotifier, FetchState>(
  (ref) => _MemberNotifier(),
);

class _MemberNotifier extends StateNotifier<FetchState> {
  _MemberNotifier() : super(Fetching());

  fetch(int gymID) async {
    try {
      state = Fetching();
      final result = await api.getGymUsers(gymID);
      state = Fetched<List<MUsermodel>>(result);
    } catch (e) {
      state = FetchError(e);
      rethrow;
    }
  }
}
