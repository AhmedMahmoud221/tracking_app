import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

class CreateDeviceUseCase {
  final DeviceRepository repository;

  CreateDeviceUseCase(this.repository);

  Future<DeviceEntity> call(DeviceEntity device) async {
    return await repository.createDevice(device);
  }
}
