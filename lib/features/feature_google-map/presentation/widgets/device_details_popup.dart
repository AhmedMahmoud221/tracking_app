import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceDetailsPopup extends StatelessWidget {
  final DeviceEntity device;
  final VoidCallback onMore;

  const DeviceDetailsPopup({
    super.key,
    required this.device,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الجهاز
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                backgroundImage: AssetImage(AssetsData.caricon),
              ),
            ),
            const SizedBox(height: 16),

            // اسم الماركة والموديل
            Align(
              alignment: Alignment.center,
              child: Text(
                device.brand,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                device.model,
                style: TextStyle(fontSize: 18, color: textColor),
              ),
            ),
            const SizedBox(height: 16),

            // Container لكل البيانات
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.black12,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: device.status.toLowerCase() == "moving"
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Status: ${device.status}',
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Last location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Last location: ${device.lastLocation.coordinates[1]}, ${device.lastLocation.coordinates[0]}',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Speed
                  Text(
                    'Speed: ${device.speed}',
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark ? Colors.transparent : Colors.white,
                    side: BorderSide(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[700]
                        : Colors.blueAccent,
                  ),
                  child: Text('More', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
