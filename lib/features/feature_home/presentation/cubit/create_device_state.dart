import 'package:equatable/equatable.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

abstract class CreateDeviceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateDeviceInitial extends CreateDeviceState {}

class CreateDeviceLoading extends CreateDeviceState {}

class CreateDeviceSuccess extends CreateDeviceState {
  final DeviceEntity device;

  CreateDeviceSuccess(this.device);

  @override
  List<Object?> get props => [device];
}

class CreateDeviceError extends CreateDeviceState {
  final String message;

  CreateDeviceError(this.message);

  @override
  List<Object?> get props => [message];
}
