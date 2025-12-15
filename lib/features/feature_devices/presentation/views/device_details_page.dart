import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

class DeviceDetailsPage extends StatelessWidget {
  final DeviceEntity device;

  const DeviceDetailsPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : Colors.white;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final borderColor = isDark ? Colors.white24 : Colors.grey.withOpacity(0.3);
    final textColor = isDark ? Colors.white : Colors.black87;
    //final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Device Details', style: TextStyle(color: textColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(AssetsData.caricon),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brand : ${device.brand}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Model : ${device.model}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Year : ${device.year}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Plate Number : ${device.plateNumber}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Status : ${device.status}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Speed : ${device.speed}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  Text(
                    'Last Location',
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: borderColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            device.lastLocation.coordinates[1], 
                            device.lastLocation.coordinates[0],
                          ),
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId(device.id),
                            position: LatLng(
                              device.lastLocation.coordinates[1], 
                              device.lastLocation.coordinates[0],
                            ),
                          ),
                        },
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        mapToolbarEnabled: false,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
