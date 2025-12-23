import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final token = await authService.login(email: email, password: password);
      await SecureStorage.saveToken(token); // ← هنا
      print(token);
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
      final token = await authService.signup(
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

  Future<void> forgetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await authService.forgetPassword(email: email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
