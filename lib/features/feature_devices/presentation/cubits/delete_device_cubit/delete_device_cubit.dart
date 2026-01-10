import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_home/domain/delete_device_use_case.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/delete_device_cubit/delete_device_state.dart';

class DeleteDeviceCubit extends Cubit<DeleteDeviceState> {
  final DeleteDeviceUseCase deleteDeviceUseCase;

  DeleteDeviceCubit(this.deleteDeviceUseCase) : super(DeleteDeviceInitial());

  Future<void> deleteDevice(String deviceId) async {
    emit(DeleteDeviceLoading());

    try {
      await deleteDeviceUseCase(deviceId);
      emit(DeleteDeviceSuccess(deviceId));
    } catch (e) {
      emit(DeleteDeviceError(e.toString()));
    }
  }
}
