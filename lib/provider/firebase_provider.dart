import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/states/auth_state.dart';

import '../services/firebase_authenticate.dart';

final firebaseProvider = StateNotifierProvider<_FirebaseNotifier, AuthState>(
  (ref) => _FirebaseNotifier(),
);

class _FirebaseNotifier extends StateNotifier<AuthState> {
  _FirebaseNotifier() : super(Checking()) {
    fetch();
  }
  void fetch() async {
    try {
      state = Checking();
      final result = await auth.authCheck();

      state = Checked<bool>(result);
    } catch (e) {
      state = CheckError(e);
      rethrow;
    }
  }

  void login(String email, String password) async {
    try {
      state = Checking();
      final result = await auth.authLogin(email, password);

      state = Checked<bool>(result);
    } catch (e) {
      state = CheckError(e);
      rethrow;
    }
  }
}
