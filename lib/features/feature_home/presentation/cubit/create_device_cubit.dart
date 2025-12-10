import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_home/domain/create_device_use_case.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_state.dart';

class CreateDeviceCubit extends Cubit<CreateDeviceState> {
  final CreateDeviceUseCase createDeviceUseCase;

  CreateDeviceCubit(this.createDeviceUseCase) : super(CreateDeviceInitial());

  Future<void> createDevice(DeviceEntity device) async {
    emit(CreateDeviceLoading());

    try {
      final result = await createDeviceUseCase(device);
      emit(CreateDeviceSuccess(result));
    } catch (e) {
      emit(CreateDeviceError(e.toString()));
    }
  }
}
