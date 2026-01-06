import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/extensions/status_localization_extension.dart';
import 'package:live_tracking/core/utils/assets.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
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
    setState(() => _carMarker = marker);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return BlocBuilder<DevicesCubit, DevicesState>(
    builder: (context, state) {
      DeviceEntity currentDevice = widget.device;

    if (state is DevicesLoaded) {
      currentDevice = state.devices.firstWhere(
        (d) => d.id == widget.device.id,
        orElse: () => currentDevice, 
      );
      // print("UI Updated with new brand: ${currentDevice.brand}");
    }
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: Column(
            key: ValueKey('${currentDevice.id}_${currentDevice.brand}_${currentDevice.image}'),
            children: [
              _buildHeader(context, currentDevice, isDark),
              const SizedBox(height: 16),
              _buildTitleSection(currentDevice, isDark),
              const SizedBox(height: 16),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetails(currentDevice, isDark),
                    _buildLocation(currentDevice),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Widgets ---

  Widget _buildHeader(BuildContext context, DeviceEntity currentDevice, bool isDark) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: currentDevice.image != null
              ? Image.network(currentDevice.image!, fit: BoxFit.fill)
              : Image.asset(AssetsData.dodge, fit: BoxFit.fill),
        ),
        Positioned(
          top: 0, left: 0, right: 0,
          child: AppBar(
            backgroundColor: Colors.black12,
            title: Text(
              AppLocalizations.of(context)!.devicedetails,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500, color: Colors.white),
            ),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [_buildPopupMenu(context, currentDevice, isDark)],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(DeviceEntity currentDevice, bool isDark) {
    return Column(
      children: [
        Text(
          currentDevice.brand,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        Text(
          currentDevice.model,
          style: TextStyle(fontSize: 18, color: isDark ? Colors.grey[400] : Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.blue[300],
      indicatorColor: Colors.blue[300],
      tabs: [
        Tab(text: AppLocalizations.of(context)!.details),
        Tab(text: AppLocalizations.of(context)!.lastlocation),
      ],
    );
  }

  Widget _buildDetails(DeviceEntity currentDevice, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: GridView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 2.2,
        ),
        children: [
          _infoCard(Icons.calendar_today, AppLocalizations.of(context)!.year, currentDevice.year.toString(), Colors.blue, isDark),
          _infoCard(Icons.numbers, AppLocalizations.of(context)!.platenumber, currentDevice.plateNumber, Colors.grey, isDark),
          _infoCard(Icons.info_outline, AppLocalizations.of(context)!.status, currentDevice.status.localized(context), 
              currentDevice.status == 'active' ? Colors.green : Colors.red, isDark),
          _infoCard(Icons.speed, AppLocalizations.of(context)!.speed, '${currentDevice.lastRecord?.speed ?? '-'} km/h', Colors.orange, isDark),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context, DeviceEntity currentDevice, bool isDark) {
    return PopupMenuButton<int>(
      offset: const Offset(0, 45),
      color: isDark ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async{
        if (value == 1) {
          await context.push('/add_edit-device', extra: currentDevice);
          
          if (context.mounted) {
            context.read<DevicesCubit>().fetchDevices();
          }
        } else if (value == 2) {
          _showDeleteDialog(context, currentDevice);
        }
      },
      itemBuilder: (context) => [
        _buildPopupItem(1, Icons.edit, AppLocalizations.of(context)!.edit, Colors.grey, isDark),
        _buildPopupItem(2, Icons.delete, AppLocalizations.of(context)!.delete, Colors.red, isDark),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, DeviceEntity currentDevice) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(AppLocalizations.of(context)!.delete),
        content: Text(AppLocalizations.of(context)!.areyousureyouwanttodeletethisdevice),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancel,
            style: TextStyle( color: isDark ? Colors.white : Colors.black)
          )),
          TextButton(
            onPressed: () {
            Navigator.pop(dialogContext);
            
            context.read<DeleteDeviceCubit>().deleteDevice(currentDevice.id);
            
            context.pop(); 
          },
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- Helpers ---
  PopupMenuItem<int> _buildPopupItem(int value, IconData icon, String text, Color color, bool isDark) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value, Color iconColor, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 16),
          Icon(icon, color: iconColor),
          const SizedBox(width: 28),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, color: isDark ? Colors.white : Colors.grey[850],),),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(DeviceEntity currentDevice) {
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