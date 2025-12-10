import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel({
    required super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.user,
    required super.plateNumber,
    required super.type,
    required super.status,
    required super.speed,
    required super.lastLocation,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['_id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      user: json['user'],
      plateNumber: json['plateNumber'],
      type: json['type'],
      status: json['status'],
      speed: json['speed'],
      lastLocation: LastLocationModel.fromJson(json['lastLocation']),
    );
  }
}

class LastLocationModel extends LastLocationEntity {
  LastLocationModel({required super.type, required super.coordinates});

  factory LastLocationModel.fromJson(Map<String, dynamic> json) {
    return LastLocationModel(
      type: json['type'],
      coordinates: List<double>.from(
        json['coordinates'].map((e) => e.toDouble()),
      ),
    );
  }
}
