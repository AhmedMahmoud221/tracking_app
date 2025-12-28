import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

abstract class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {}

class DevicesLoaded extends DevicesState {
  final List<DeviceEntity> devices;
  final DeviceEntity? selectedDevice;
  final DateTime? temp;

  DevicesLoaded(this.devices, this.selectedDevice, this.temp);
}

class DevicesError extends DevicesState {
  final String message;

  DevicesError(this.message);
}
