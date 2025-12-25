import 'package:flutter/material.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

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

    Color statusColor;
    String statusText;

    switch (device.status.toLowerCase()) {
      case 'moving':
        statusColor = Colors.green;
        statusText = AppLocalizations.of(context)!.moving;
        break;

      case 'parking':
        statusColor = Colors.blue;
        statusText = AppLocalizations.of(context)!.parking;
        break;

      case 'idling':
        statusColor = Colors.orange;
        statusText = AppLocalizations.of(context)!.idling;
        break;

      case 'towed':
        statusColor = Colors.red;
        statusText = AppLocalizations.of(context)!.towed;
        break;

      default:
        statusColor = Colors.grey;
        statusText = device.status;
    }

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
              child: ClipOval(
                child: Image.asset(
                  AssetsData.freepik,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
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
                      Icon(Icons.circle, size: 12, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        '${AppLocalizations.of(context)!.status} : $statusText',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
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
                          device.lastRecord != null
                              ? '${AppLocalizations.of(context)!.lastlocation} : ${device.lastRecord!.lat}, ${device.lastRecord!.lng}'
                              : '${AppLocalizations.of(context)!.lastlocation} : Not available',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Speed
                  Row(
                    children: [
                      Icon(Icons.speed, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${AppLocalizations.of(context)!.speed} : ${device.lastRecord?.speed}',
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.more,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark ? Colors.transparent : Colors.white,
                    side: BorderSide(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.close,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
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
