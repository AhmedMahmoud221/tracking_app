import 'package:live_tracking/features/feature_devices/domain/entities/user_entity.dart';

class DeviceEntity {
  final String id;
  final String brand;
  final String model;
  final int year;
  final UserEntity user;
  final String plateNumber;
  final String type;
  final String status;
  //final dynamic speed;
  final LastRecordEntity? lastRecord;

  DeviceEntity({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.user,
    required this.plateNumber,
    required this.type,
    required this.status,
    //required this.speed,
    required this.lastRecord,
  });
}

class LastRecordEntity {
  final double lat;
  final double lng;
  final double speed;
  final String status;
  final double rotation;
  final DateTime timestamp;

  LastRecordEntity({
    required this.lat,
    required this.lng,
    required this.speed,
    required this.status,
    required this.rotation,
    required this.timestamp,
  });
}
