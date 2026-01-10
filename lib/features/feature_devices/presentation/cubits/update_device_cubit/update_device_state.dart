import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

abstract class UpdateDeviceState {}

class UpdateDeviceInitial extends UpdateDeviceState {}

class UpdateDeviceLoading extends UpdateDeviceState {}

class UpdateDeviceSuccess extends UpdateDeviceState {
  final DeviceEntity device;
  UpdateDeviceSuccess(this.device);
}

class UpdateDeviceError extends UpdateDeviceState {
  final String message;
  UpdateDeviceError(this.message);
}
