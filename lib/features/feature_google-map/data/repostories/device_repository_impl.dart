import 'package:live_tracking/features/feature_google-map/data/data_sources/device_remote_data_source.dart';
import 'package:live_tracking/features/feature_google-map/domain/entities/vehicle_map.dart';

abstract class DeviceRepository {
  Future<List<Device>> getAllDevices();
}

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remote;

  DeviceRepositoryImpl(this.remote);

  @override
  Future<List<Device>> getAllDevices() {
    return remote.fetchDevices();
  }
}
