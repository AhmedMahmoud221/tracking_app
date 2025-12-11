import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceCardGrid extends StatelessWidget {
  final DeviceEntity device;

  const DeviceCardGrid({super.key, required this.device});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "parking":
        return Colors.blue;
      case "moving":
        return Colors.green;
      case "idling":
        return Colors.orange;
      case "towed":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
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
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: 12,),
                      Text(
                      device.brand,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 6,),
                      // الموديل
                      Text(
                        device.model,
                        style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(device.status).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        device.status,
                        style: TextStyle(
                          color: _getStatusColor(device.status),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),   

            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Plate Number ${device.plateNumber}',
                  style: TextStyle(
                    fontSize: 16, 
                    color: Colors.grey[600], 
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),        
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
