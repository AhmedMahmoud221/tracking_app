import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/device_details_page.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/custom_bottom_sheet.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/device_details_popup.dart';

class GoogleMapPage extends StatefulWidget {
  final DeviceEntity? initialDevice;
  const GoogleMapPage({super.key, this.initialDevice});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late final Completer<GoogleMapController> _controllerCompleter;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _controllerCompleter = Completer();

    final initialDevice = widget.initialDevice;
    if (initialDevice != null) {
      context.read<DevicesCubit>().selectDevice(initialDevice);
    } else {
      context.read<DevicesCubit>().fetchDevices();
    }
  }

  Future<void> _setMapStyle(bool isDark) async {
    if (_mapController == null) return;
    final style = isDark
        ? await DefaultAssetBundle.of(
            context,
          ).loadString('assets/google_map_theme/dark_map_style.json')
        : null;
    await _mapController!.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    // استمع لتغير ThemeCubit
    final isDark = context.watch<ThemeCubit>().state == ThemeState.dark;

    // حدث style مباشرة بعد أي build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setMapStyle(isDark);
    });

    return BlocConsumer<DevicesCubit, DevicesState>(
      listener: (context, state) async {
        if (state is DevicesLoaded && state.selectedDevice != null) {
          final coords = state.selectedDevice!.lastLocation.coordinates;
          await _mapController?.animateCamera(
            CameraUpdate.newLatLng(LatLng(coords[1], coords[0])),
          );
        }
      },
      builder: (context, state) {
        List<DeviceEntity> devices = [];
        bool loading = false;
        if (state is DevicesLoading) loading = true;
        if (state is DevicesLoaded) devices = state.devices;

        final markers = context.read<DevicesCubit>().getMarkers();

        final initialPosition = widget.initialDevice != null
            ? LatLng(
                widget.initialDevice!.lastLocation.coordinates[1],
                widget.initialDevice!.lastLocation.coordinates[0],
              )
            : const LatLng(30.0, 31.0);

        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: initialPosition,
                  zoom: 12,
                ),
                markers: markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                  if (!_controllerCompleter.isCompleted) {
                    _controllerCompleter.complete(controller);
                  }
                  // عند الإنشاء حدث style مباشرة
                  _setMapStyle(isDark);
                },
              ),
              if (loading) const Center(child: CircularProgressIndicator()),
              Positioned(
                bottom: 20,
                right: 20,
                child: CustomBottomSheet(
                  devices: devices,
                  onSelect: (device) {
                    context.read<DevicesCubit>().selectDevice(device);
                    _showDeviceDetails(device);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeviceDetails(DeviceEntity device) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DeviceDetailsPopup(
          device: device,
          onMore: () {
            Navigator.pop(context); // تقفل البوب أب
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DeviceDetailsPage(device: device),
              ),
            );
          },
        );
      },
    );
  }
}
