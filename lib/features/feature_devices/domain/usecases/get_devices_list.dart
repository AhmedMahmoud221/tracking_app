import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

class GetDevicesList {
  final DeviceRepository repository;

  GetDevicesList(this.repository);

  Future<List<DeviceEntity>> call() async {
    return await repository.getDevices();
  }
}
