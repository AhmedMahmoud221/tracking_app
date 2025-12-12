import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceDetailsPage extends StatelessWidget {
  final DeviceEntity device;

  const DeviceDetailsPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Device Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الجهاز
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(AssetsData.caricon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              ' ${device.brand}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3), // بوردر خفيف
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الموديل
                  Text(
                    'Model: ${device.model}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // السنة
                  Text(
                    'Year: ${device.year}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // رقم اللوحة
                  Text(
                    'Plate Number: ${device.plateNumber}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // الحالة
                  Text(
                    'Status: ${device.status}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // اللوكيشن
                  Text(
                    'Last Location: ${device.lastLocation}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // السرعة
                  Text(
                    'Speed: ${device.speed}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
