import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

class DeleteDeviceUseCase {
  final DeviceRepository repository;

  DeleteDeviceUseCase(this.repository);

  Future<void> call(String deviceId) async {
    await repository.deleteDevice(deviceId);
  }
}
