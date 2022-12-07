import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymbro_web/enums/accoun_type.dart';
import 'package:gymbro_web/states/auth_state.dart';

import '../services/api_service.dart';

final authProvider = StateNotifierProvider<_AuthNotifier, AuthState>(
  (ref) => _AuthNotifier(),
);

class _AuthNotifier extends StateNotifier<AuthState> {
  _AuthNotifier() : super(Checking());

  fetch(String email) async {
    try {
      state = Checking();
      final result = await api.checkAdmin(email);
      state = Checked<AccountType>(result);
    } catch (e) {
      state = CheckError(e);
      rethrow;
    }
  }
}
