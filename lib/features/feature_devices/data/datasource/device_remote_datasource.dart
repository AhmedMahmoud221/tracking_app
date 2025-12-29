import 'package:dio/dio.dart';
import 'package:live_tracking/core/constants/api_constants.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_devices/data/models/device_model.dart';
import 'package:live_tracking/features/feature_home/data/models/create_device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getDevices();
  Future<DeviceModel> createDevice(
    CreateDeviceModel device,
  ); // نستخدم DeviceModel عشان فيها toJson
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio dio;

  DeviceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DeviceModel>> getDevices() async {
    final token = await SecureStorage.readToken() ?? "";

    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/user/device',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    final List list = response.data['data']['devices'];

    return list.map((e) => DeviceModel.fromJson(e)).toList();
  }

  @override
  Future<DeviceModel> createDevice(CreateDeviceModel device) async {
    final token = await SecureStorage.readToken() ?? "";

    final response = await dio.post(
      '${ApiConstants.baseUrl}/api/user/device',
      data: device.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    return DeviceModel.fromJson(response.data["data"]);
  }

  Future<DeviceModel> updateDevice(
    String deviceId,
    CreateDeviceModel device,
  ) async {
    final token = await SecureStorage.readToken() ?? "";

    final response = await dio.put(
      '${ApiConstants.baseUrl}/api/user/device/$deviceId',
      data: device.toJson(),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    return DeviceModel.fromJson(response.data["data"]);
  }
}