import 'package:dio/dio.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
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
      'https://v05j2rv7-5000.euw.devtunnels.ms/api/user/device',
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
      'https://v05j2rv7-5000.euw.devtunnels.ms/api/user/device',
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
