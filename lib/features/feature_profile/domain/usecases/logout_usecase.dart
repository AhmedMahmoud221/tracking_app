import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_login/data/models/auth_service.dart';

class LogoutUseCase {
  final AuthService authService;

  LogoutUseCase(this.authService);

  Future<void> call(String? token) async {
    if (token != null) {
      await authService.logoutbutton(token);
    }
    await SecureStorage.deleteToken();
  }
}
