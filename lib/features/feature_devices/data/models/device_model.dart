import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel({
    required super.id,
    required super.name,
    required super.model, // ← جديد
    required super.imagePath, // ← جديد
    required super.status,
    required super.speed,
    required super.lat,
    required super.lng,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json["id"],
      name: json["name"],
      model: json["model"] ?? "Unknown", // ← جديد
      imagePath: json["imagePath"] ?? "assets/car.png", // ← جديد
      status: json["status"],
      speed: (json["speed"] as num).toDouble(),
      lat: (json["lat"] as num).toDouble(),
      lng: (json["lng"] as num).toDouble(),
    );
  }
}
