import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

abstract class DeviceRepository {
  Future<List<DeviceEntity>> getDevices();
}
