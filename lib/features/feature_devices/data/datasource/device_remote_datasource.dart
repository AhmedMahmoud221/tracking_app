import 'package:dio/dio.dart';
import 'package:live_tracking/features/feature_devices/data/models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<List<DeviceModel>> getDevices();
}

class DeviceRemoteDataSourceImpl implements DeviceRemoteDataSource {
  final Dio dio;

  DeviceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DeviceModel>> getDevices() async {
    final response = await dio.get("https://v05j2rv7-5000.euw.devtunnels.ms/");

    final List list = response.data['data']['devices'];

    return list.map((e) => DeviceModel.fromJson(e)).toList();
  }
}
