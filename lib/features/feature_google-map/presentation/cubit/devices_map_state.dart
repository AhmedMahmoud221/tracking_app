import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

abstract class DevicesMapState {}

class DevicesInitial extends DevicesMapState {}

class DevicesLoading extends DevicesMapState {}

class DevicesLoaded extends DevicesMapState {
  final List<DeviceEntity> devices;
  final DeviceEntity? selected;

  DevicesLoaded({required this.devices, this.selected});
}

class DevicesError extends DevicesMapState {
  final String message;
  DevicesError(this.message);
}
