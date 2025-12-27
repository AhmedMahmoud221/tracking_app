import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/extensions/status_localization_extension.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/delete_device_cubit/delete_device_cubit.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class DeviceDetailsPage extends StatefulWidget {
  final DeviceEntity device;

  const DeviceDetailsPage({super.key, required this.device});

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  BitmapDescriptor? _carMarker;

  @override
  void initState() {
    super.initState();
    _loadCarMarker();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _loadCarMarker() async {
    final marker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/images/map_Icon.png',
    );

    if (!mounted) return;

    setState(() {
      _carMarker = marker;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.device;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 400,
                width: double.infinity,
                child: device.image != null
                    ? Image.network(
                        device.image!,
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.broken_image, size: 50),
                          );
                        },
                      )
                    : Image.asset(AssetsData.dodge, fit: BoxFit.fill),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.black12,
                  title: Text(
                    AppLocalizations.of(context)!.devicedetails,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    PopupMenuButton<int>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: isDark ? Colors.grey[850] : Colors.white,
                      offset: const Offset(0, 40),

                      onSelected: (value) {
                        if (value == 1) {
                          context.push('/create-device', extra: device);
                        }

                        if (value == 2) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text(AppLocalizations.of(context)!.delete),
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.areyousureyouwanttodeletethisdevice,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<DeleteDeviceCubit>()
                                        .deleteDevice(device.id);
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.delete,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20, color: Colors.grey),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.edit,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              const SizedBox(width: 6),
                              Text(
                                AppLocalizations.of(context)!.delete,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Model & Brand
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    device.brand,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    device.model,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue[300],
            unselectedLabelColor: isDark ? Colors.grey[400] : Colors.black54,
            indicatorColor: Colors.blue[300],
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            tabs: [
              Tab(text: AppLocalizations.of(context)!.details),
              Tab(text: AppLocalizations.of(context)!.lastlocation),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetails(isDark: isDark),
                _buildLocation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails({required bool isDark}) {
    final device = widget.device;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GridView(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2,
        ),
        children: [
          _infoCard(
            icon: Icons.calendar_today,
            title: AppLocalizations.of(context)!.year,
            value: device.year.toString(),
            iconColor: Colors.blue,
            isDark: isDark,
          ),
          _infoCard(
            icon: Icons.numbers,
            title: AppLocalizations.of(context)!.platenumber,
            value: device.plateNumber,
            iconColor: Colors.grey,
            isDark: isDark,
          ),
          _infoCard(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context)!.status,
            value: device.status.localized(context),
            iconColor: device.status == 'active' ? Colors.green : Colors.red,
            isDark: isDark,
          ),
          _infoCard(
            icon: Icons.speed,
            title: AppLocalizations.of(context)!.speed,
            value: '${device.lastRecord?.speed.toString() ?? '-'} km/h',
            iconColor: Colors.orange,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black54
                : Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha((0.1 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocation() {
    final device = widget.device;
    GoogleMapController? mapController;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    void setMapStyle() async {
      if (mapController == null) return;
      final style = isDark
          ? await DefaultAssetBundle.of(
              context,
            ).loadString('assets/google_map_theme/dark_map_style.json')
          : null;
      await mapController!.setMapStyle(style);
    }

    return Padding(
      padding: const EdgeInsets.all(0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: device.lastRecord != null
                ? LatLng(device.lastRecord!.lat, device.lastRecord!.lng)
                : const LatLng(30.0, 31.0),
            zoom: 14,
          ),
          markers: {
            Marker(
              markerId: MarkerId(device.id),
              position: device.lastRecord != null
                  ? LatLng(device.lastRecord!.lat, device.lastRecord!.lng)
                  : const LatLng(30.0, 31.0),
              icon:
                  _carMarker ??
                  BitmapDescriptor
                      .defaultMarker, // لو الصورة لسه محملة استخدم الديفولت
              infoWindow: InfoWindow(
                title: device.model,
                snippet: device.plateNumber, // هنا يظهر كود العربية
              ),
            ),
          },
          zoomControlsEnabled: false,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          mapToolbarEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            setMapStyle();
          },
        ),
      ),
    );
  }
}
