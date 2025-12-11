import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceCardGrid extends StatelessWidget {
  final DeviceEntity device;

  const DeviceCardGrid({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/device-details', extra: device);
      },
      child: Card(
        color: const Color.fromARGB(252, 252, 252, 252),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // صورة الجهاز
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(AssetsData.caricon), // placeholder لو مفيش صورة
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // النوع
            Text(
              device.brand,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // الموديل
            Text(
              device.model,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),

            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  // هنا تضيف اللي عايز يحصل لما يضغط على الزر
                  print('More pressed');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 88, 180, 255), // لون الزر
                  padding: const EdgeInsets.symmetric(vertical: 4), // ارتفاع الزر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // حواف مدورة
                  ),
                  elevation: 1, // شادو خفيف
                ),
                child: const Text(
                  'More',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
