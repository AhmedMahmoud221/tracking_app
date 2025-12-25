import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/extensions/status_localization_extension.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => context.push('/device-details', extra: device),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final imageHeight = cardWidth * 0.70;

          return Card(
            color: isDark
                ? Colors.grey[850]
                : const Color.fromARGB(252, 252, 252, 252),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة الجهاز
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: imageHeight,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[300] : Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: device.image != null
                        ? DecorationImage(
                            image: NetworkImage(device.image!),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(AssetsData.freepik), // الصورة الافتراضية
                            fit: BoxFit.cover,
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                // Brand + Model + Status
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column: Brand + Model
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              device.brand,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: cardWidth < 180 ? 15 : 18,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              device.model,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: cardWidth < 180 ? 13 : 16,
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Badge
                      FittedBox(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              device.status,
                            ).withAlpha((0.12 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            device.status.localized(context),
                            style: TextStyle(
                              fontSize: cardWidth < 180 ? 12 : 14,
                              color: _getStatusColor(device.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Plate Number
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${AppLocalizations.of(context)!.number} : ${device.plateNumber}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: cardWidth * 0.08,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
