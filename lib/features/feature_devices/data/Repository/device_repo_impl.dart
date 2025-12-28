import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_devices/data/datasource/device_remote_datasource.dart';
import 'package:live_tracking/features/feature_devices/data/models/device_model.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final Dio dio;
  final DeviceRemoteDataSource remoteDataSource;

  DeviceRepositoryImpl(this.remoteDataSource, {required this.dio});

  @override
  Future<List<DeviceEntity>> getDevices() async {
    return await remoteDataSource.getDevices();
  }

  @override
  Future<DeviceEntity> createDevice(DeviceEntity device, {File? image}) async {
    final token = await SecureStorage.readToken();
    final formData = FormData.fromMap({
      'brand': device.brand,
      'model': device.model,
      'year': device.year,
      'plateNumber': device.plateNumber,
      'type': device.type,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await dio.post(
      '${ApiConstants.baseUrl}/api/user/device',
      data: formData,
      options: Options(contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer $token',
        }
      ),
    );

    return DeviceModel.fromJson(response.data);
  }

  @override
  Future<DeviceEntity> updateDevice(DeviceEntity device, {File? image}) async {
    final token = await SecureStorage.readToken();
    final formData = FormData.fromMap({
      'brand': device.brand,
      'model': device.model,
      'year': device.year,
      'plateNumber': device.plateNumber,
      'type': device.type,
      if (image != null)
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    final response = await dio.patch(
      '${ApiConstants.baseUrl}/api/user/device/${device.id}',
      data: formData,
      options: Options(contentType: 'multipart/form-data',
        headers: {
          'Authorization': 'Bearer $token',
        }
      ),
    );

    return DeviceModel.fromJson(response.data);
  }

  @override
  Future<void> deleteDevice(String deviceId) async {
    final token = await SecureStorage.readToken();
    await dio.delete('${ApiConstants.baseUrl}/api/user/device/$deviceId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        }
      )
    );
  }
}
