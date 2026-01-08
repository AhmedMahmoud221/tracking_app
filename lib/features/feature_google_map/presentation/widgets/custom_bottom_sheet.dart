import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<DeviceEntity> devices;
  final void Function(DeviceEntity) onSelect;

  const CustomBottomSheet({
    super.key,
    required this.devices,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[850] : Colors.white;
    final sheetBgColor = isDark ? Colors.grey[900] : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black87;

    return InkWell(
      onTap: () {
        showMaterialModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(
              height: 650,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.devices,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: devices.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final d = devices[index];
                        final statusColor = d.status.toLowerCase() == "moving"
                            ? Colors.green
                            : Colors.red;

                        return InkWell(
                          onTap: () {
                            Navigator.pop(context); // close sheet
                            onSelect(d);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: sheetBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [

                                _buildDeviceThumbnail(d.image, isDark),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            d.brand,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            d.model,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        (d.lastRecord?.speed == null) 
                                            ? "Out of Service" 
                                            : '${AppLocalizations.of(context)!.speed} : ${d.lastRecord!.speed} km/h',
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      d.status.toLowerCase() == "moving"
                                          ? AppLocalizations.of(context)!.online
                                          : AppLocalizations.of(
                                              context,
                                            )!.offline,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: _buildFloatingActionIcon(devices.isNotEmpty ? devices.first.image : null)
    );
  }
  // ويدجت لعرض صورة الجهاز المصغرة داخل القائمة
  Widget _buildDeviceThumbnail(String? imageUrl, bool isDark) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: (imageUrl != null && imageUrl.isNotEmpty)
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.directions_car, size: 30),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                },
              )
            : const Icon(Icons.directions_car, size: 30, color: Colors.grey),
      ),
    );
  }

  // ويدجت للزر العائم الخارجي
  Widget _buildFloatingActionIcon(String? imageUrl) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.directions_car, color: Colors.blue),
                )
              : const Icon(Icons.directions_car, color: Colors.blue),
        ),
      ),
    );
  }
}