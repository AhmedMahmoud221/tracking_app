abstract class DeleteDeviceState {}

class DeleteDeviceInitial extends DeleteDeviceState {}

class DeleteDeviceLoading extends DeleteDeviceState {}

class DeleteDeviceSuccess extends DeleteDeviceState {
  final String deviceId;
  DeleteDeviceSuccess(this.deviceId);
}

class DeleteDeviceError extends DeleteDeviceState {
  final String message;
  DeleteDeviceError(this.message);
}
