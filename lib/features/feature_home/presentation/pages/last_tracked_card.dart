import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/core/extensions/status_localization_extension.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class LastTrackedCard extends StatelessWidget {
  final dynamic device; // هتربطه بالـ DeviceEntity بعدين
  final void Function(DeviceEntity device) onTrack;
  
  const LastTrackedCard({super.key, this.device, required this.onTrack});

  @override
  Widget build(BuildContext context) {
    final lastDevice = device; // الجهاز الأخير
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDark ? Colors.grey[850] : Colors.grey[100],
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.lasttrackeddevice,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              device != null ? '${device.brand} ${device.model}' : 'No Device',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(
                    "${device.status}".localized(context),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  backgroundColor: isDark ? Colors.grey[700] : Colors.white,
                ),
                Chip(
                  label: Text(
                    '${AppLocalizations.of(context)!.moving} ${device.lastRecord?.speed ?? 0} km/h',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  backgroundColor: isDark ? Colors.grey[700] : Colors.white,
                ),
                Chip(
                  label: Text(
                    '${device.plateNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  backgroundColor: isDark ? Colors.grey[700] : Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: device == null
                    ? null
                    : () {
                        onTrack(device!);
                        // حدّد الجهاز الأخير في DevicesCubit
                        context.read<DevicesCubit>().selectDevice(device);
                        // optional: scroll أو تركيز الماب
                      },
                  icon: const Icon(Icons.location_searching),
                  label: Text(AppLocalizations.of(context)!.tracknow),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: isDark ? Colors.white : Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (lastDevice != null) {
                      context.push('/device-details', extra: lastDevice);
                    }
                  },
                  icon: const Icon(Icons.info_outline),
                  label: Text(AppLocalizations.of(context)!.details),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark
                        ? Colors.grey[800]
                        : Colors.grey[300],
                    foregroundColor: isDark ? Colors.white : Colors.black,
                    side: BorderSide(
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
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
