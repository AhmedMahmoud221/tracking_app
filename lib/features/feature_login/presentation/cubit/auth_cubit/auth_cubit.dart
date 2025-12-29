import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  // Login method
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      // 1. استدعاء الدالة وتخزين النتيجة في authData
      final Map<String, dynamic> authData = await authService.login(email: email, password: password);
      
      // 2. استخراج البيانات من authData (مش من authService)
      final String token = authData['token'];
      final String userId = authData['userId']; // شلنا await وشلنا authService

      // 3. حفظ البيانات
      await SecureStorage.saveUserData(token: token, userId: userId);
      
      print("Token: $token");
      print("User ID: $userId");

      emit(AuthSuccess(token: token));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // Signup method
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

  // Forget Password method
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
