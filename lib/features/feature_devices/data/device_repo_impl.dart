// // lib/features/feature_devices/data/repo/devices_repo_impl.dart
// import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
// import 'package:live_tracking/features/feature_devices/domain/repo/device_repo.dart';

// class DevicesRepoImpl implements DevicesRepo {
//   @override
//   Future<List<DeviceEntity>> getDevices() async {
//     await Future.delayed(const Duration(milliseconds: 600));

//     return List.generate(20, (i) {
//       return DeviceEntity(
//         id: "DEV-$i",
//         name: "Device $i",
//         model: "Model ${i + 2020}",
//         imagePath: "assets/car.png",
//         status: i % 2 == 0 ? "online" : "offline",
//         speed: (5 + i).toDouble(),
//         lat: 30.05 + i * 0.001,
//         lng: 31.20 + i * 0.001,
//       );
//     });
//   }
// }
