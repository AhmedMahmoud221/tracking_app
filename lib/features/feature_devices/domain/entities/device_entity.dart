class DeviceEntity {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String user;
  final String plateNumber;
  final String type;
  final String status;
  final int speed;
  final LastLocationEntity lastLocation;

  DeviceEntity({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.user,
    required this.plateNumber,
    required this.type,
    required this.status,
    required this.speed,
    required this.lastLocation,
  });
}

class LastLocationEntity {
  final String type;
  final List<double> coordinates;

  LastLocationEntity({
    required this.type,
    required this.coordinates,
  });
}
