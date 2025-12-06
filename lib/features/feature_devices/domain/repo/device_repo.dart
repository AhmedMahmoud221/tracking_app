import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

abstract class DevicesRepo {
  Future<List<DeviceEntity>> getDevices();
}
