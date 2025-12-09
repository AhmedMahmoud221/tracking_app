import 'package:dio/dio.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_devices/data/models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getDevices();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio dio;

  DeviceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DeviceModel>> getDevices() async {
    final token = await SecureStorage.readToken() ?? "";
    print('token is ${token}');

    final response = await dio.get(
      'https://v05j2rv7-5000.euw.devtunnels.ms/api/user/device',
      options: Options(
        headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        },
      ),
    );

    print(response);

    final List list = response.data['data']['devices'];

    return list.map((e) => DeviceModel.fromJson(e)).toList();
  }
}
