class CreateDeviceModel {
  final String brand;
  final String model;
  final int year;
  final String plateNumber;
  final String type;

  CreateDeviceModel({
    required this.brand,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "brand": brand,
      "model": model,
      "year": year,
      "plateNumber": plateNumber,
      "type": type,
    };
  }
}
