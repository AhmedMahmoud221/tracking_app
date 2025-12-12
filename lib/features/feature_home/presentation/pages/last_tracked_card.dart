// -------------------------- LAST TRACKED CARD --------------------------
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LastTrackedCard extends StatelessWidget {
  final dynamic device; // هتربطه بالـ DeviceEntity بعدين
  const LastTrackedCard({super.key, this.device});

  @override
  Widget build(BuildContext context) {
    final lastDevice = device; // الجهاز الأخير

    return Card(
      color: Colors.grey[100],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Last Tracked Device',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              device != null ? '${device.brand} ${device.model}' : 'No Device',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: const [
                Chip(
                  label: Text('Online', style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.white,
                ),
                Chip(
                  label: Text('Moving 42 km/h', style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.white,
                ),
                Chip(
                  label: Text('Batt 76%', style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (device != null) {
                      context.push('/google-map', extra: device);
                    }
                  },
                  icon: const Icon(Icons.location_searching),
                  label: const Text('Track Now'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (lastDevice != null) {
                      // لو عايز تروح لصفحة التفاصيل
                      context.push('/device-details', extra: lastDevice);
                    }
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // ← الخلفية بيضا
                    foregroundColor: Colors.black, // ← النص / الأيقونة أسود
                    side: const BorderSide(
                      color: Colors.grey,
                    ), // ← تعديل البوردر لو تحب
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
