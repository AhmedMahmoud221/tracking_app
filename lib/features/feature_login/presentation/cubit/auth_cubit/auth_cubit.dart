import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final token = await _authService.login(email: email, password: password);
      await SecureStorage.saveToken(token); // ← هنا
      emit(AuthSuccess(token: token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AuthLoading());
    try {
      final token = await _authService.signup(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      await SecureStorage.saveToken(token); // for save token to secure storage
      emit(AuthSuccess(token: token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
