import 'package:live_tracking/features/feature_devices/data/datasource/device_remote_datasource.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';
import 'package:live_tracking/features/feature_home/data/models/create_device_model.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DeviceEntity>> getDevices() async {
    return await remoteDataSource.getDevices();
  }

  @override
  Future<DeviceEntity> createDevice(DeviceEntity device) async {
    final createModel = CreateDeviceModel(
      brand: device.brand,
      model: device.model,
      year: device.year,
      plateNumber: device.plateNumber,
      type: device.type,
    );

    return await remoteDataSource.createDevice(createModel);
  }
}
