// import 'package:dio/dio.dart';
// import 'package:live_tracking/features/feature_devices/data/models/device_model.dart';

// class DeviceMapRemoteDataSource {
//   final Dio dio;

//   DeviceMapRemoteDataSource(this.dio);

//   Future<List<DeviceModel>> fetchDevices() async {
//     final response = await dio.get('https://v05j2rv7-5000.euw.devtunnels.ms/api/user/device');

//     final data = response.data['data'] as List;

//     return data.map((e) => DeviceModel.fromJson(e)).toList();
//   }
// }
