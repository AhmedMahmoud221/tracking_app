import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_login/data/models/user_model.dart';

class DeviceModel extends DeviceEntity {
  @override
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
    id: json['_id']?.toString() ?? '',
    brand: json['brand']?.toString() ?? '',
    model: json['model']?.toString() ?? '',
    year: json['year'] ?? 0,
    // حماية حقل المستخدم: إذا كان الـ user نل، ننشئ مستخدم وهمي بدلاً من الانهيار
    user: json['user'] != null 
        ? UserModel.fromJson(json['user']) 
        : UserModel(id: '', name: 'Unknown', email: ''), 
    plateNumber: json['plateNumber']?.toString() ?? '',
    type: json['type']?.toString() ?? 'Car',
    status: json['status']?.toString() ?? 'inactive',
    lastRecord: json['lastRecord'] != null
        ? LastRecordModel.fromJson(json['lastRecord'])
        : null,
    image: json['image']?.toString(), // تأكدنا أنه String أو Null
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
    // استخدمنا (json['...'] ?? 0) للحماية من قيم الـ Null في الأرقام
    lat: (json['lat'] ?? 0 as num).toDouble(),
    lng: (json['lng'] ?? 0 as num).toDouble(),
    speed: (json['speed'] ?? 0 as num).toDouble(),
    // الخطأ المحتمل كان هنا:
    status: json['status']?.toString() ?? 'offline', 
    rotation: (json['rotation'] ?? 0 as num).toDouble(),
    // حماية للتاريخ
    timestamp: json['timestamp'] != null 
        ? DateTime.parse(json['timestamp']) 
        : DateTime.now(),
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
