import 'dart:io';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

class UpdateDeviceUseCase {
  final DeviceRepository repository;

  UpdateDeviceUseCase(this.repository);

  Future<DeviceEntity> call({required DeviceEntity device, File? image}) async {
    return await repository.updateDevice(device, image: image);
  }
}
