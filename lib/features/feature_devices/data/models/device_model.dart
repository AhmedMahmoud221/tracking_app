import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_login/data/models/user_model.dart';

class DeviceModel extends DeviceEntity {
  final String? image; // هنا أضفنا خاصية الصورة

  DeviceModel({
    required super.id,
    required super.brand,
    required super.model,
    required super.year,
    required super.user,
    required super.plateNumber,
    required super.type,
    required super.status,
    required super.lastRecord,
    this.image, // أضفناها للكونستركتور
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['_id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      user: UserModel.fromJson(json['user']),
      plateNumber: json['plateNumber'],
      type: json['type'],
      status: json['status'],
      lastRecord: json['lastRecord'] != null
          ? LastRecordModel.fromJson(json['lastRecord'])
          : null,
      image: json['image'], // جلبنا الصورة من JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'user': user,
      'plateNumber': plateNumber,
      'type': type,
      'status': status,
      'lastRecord': lastRecord,
      'image': image, // إضافة الصورة للـ JSON
    };
  }
}

class LastRecordModel extends LastRecordEntity {
  LastRecordModel({
    required super.lat,
    required super.lng,
    required super.speed,
    required super.status,
    required super.rotation,
    required super.timestamp,
  });

  factory LastRecordModel.fromJson(Map<String, dynamic> json) {
    return LastRecordModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      status: json['status'],
      rotation: (json['rotation'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'speed': speed,
      'status': status,
      'rotation': rotation,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
