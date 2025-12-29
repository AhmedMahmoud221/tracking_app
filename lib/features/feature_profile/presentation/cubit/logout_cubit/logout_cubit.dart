import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_profile/domain/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final LogoutUseCase logoutUseCase;

  LogOutCubit(this.logoutUseCase) : super(ProfileInitial());

  Future<void> logout() async {
    emit(LogoutLoadingState());

    try {
      final token = await SecureStorage.readToken();
      await logoutUseCase(token);

      await SecureStorage.deleteToken(); // Clear all stored data on logout

      emit(LogoutSuccessState());
    } catch (e) {
      emit(LogoutErrorState(e.toString()));
    }
  }
}
