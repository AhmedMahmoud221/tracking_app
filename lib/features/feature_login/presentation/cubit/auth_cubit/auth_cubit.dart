import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());
  //--------------------------------------------
  // 1. Login Method
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final authData = await authService.login(
        email: email,
        password: password,
      );

      final String token = authData['token'];
      final String userId = authData['userId'];

      await SecureStorage.saveUserData(token: token, userId: userId);

      emit(AuthSuccess(token: token));
    } catch (e) {
      // final String errorMessage = ApiErrorHandler.handle(e);
      emit(AuthFailure('e'));
    }
  }

  //--------------------------------------------
  // 1. Check Auth Status Method
  Future<void> checkAuthStatus() async {
    final token = await SecureStorage.readToken();
    if (token != null) {
      emit(AuthSuccess(token: token));
    } else {
      emit(AuthInitial());
    }
  }

  //--------------------------------------------
  // 2. Signup Method
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AuthLoading());
    try {
      final authData = await authService.signup(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );

      final String token = authData['token'];
      final String userId = authData['userId'];

      await SecureStorage.saveUserData(token: token, userId: userId);

      emit(AuthSuccess(token: token));
    } catch (e) {
      emit(AuthFailure('errorMessage'));
    }
  }

  //--------------------------------------------
  // 3. Forget Password Method
  Future<void> forgetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await authService.forgetPassword(email: email);
      emit(ForgetPasswordSuccess());
    } catch (e) {
      emit(AuthFailure('errorMessage'));
    }
  }
}
