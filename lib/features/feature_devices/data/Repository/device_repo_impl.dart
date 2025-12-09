import 'package:live_tracking/features/feature_devices/data/datasource/device_remote_datasource.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DeviceEntity>> getDevices() async {
    return await remoteDataSource.getDevices();
  }
}
