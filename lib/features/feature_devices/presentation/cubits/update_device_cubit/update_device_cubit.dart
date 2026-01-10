import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_home/domain/update_device_use_case.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/update_device_cubit/update_device_state.dart';

class UpdateDeviceCubit extends Cubit<UpdateDeviceState> {
  final UpdateDeviceUseCase updateDeviceUseCase;

  UpdateDeviceCubit(this.updateDeviceUseCase) : super(UpdateDeviceInitial());

  Future<void> updateDevice(DeviceEntity device, {File? image}) async {
    emit(UpdateDeviceLoading());

    try {
      final result = await updateDeviceUseCase(device: device, image: image);
      emit(UpdateDeviceSuccess(result));
    } catch (e) {
      emit(UpdateDeviceError(e.toString()));
    }
  }
}
