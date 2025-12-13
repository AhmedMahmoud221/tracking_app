import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/custom_bottom_sheet.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // لو Theme اتغير، حدث ستايل الماب
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final style = isDark
          ? await rootBundle.loadString(
              'assets/google_map_theme/dark_map_style.json',
            )
          : null;
      await _mapController?.setMapStyle(style);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        final devices = state is DevicesLoaded
            ? state.devices
            : <DeviceEntity>[];
        final loading = state is DevicesLoading;

        final markers = context.read<DevicesCubit>().getMarkers();

        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(30.0, 31.0),
                  zoom: 12,
                ),
                markers: markers,
                onMapCreated: (controller) async {
                  _mapController = controller;
                  if (!_controllerCompleter.isCompleted)
                    _controllerCompleter.complete(controller);

                  final isDark =
                      Theme.of(context).brightness == Brightness.dark;
                  final style = isDark
                      ? await rootBundle.loadString(
                          'assets/google_map_theme/dark_map_style.json',
                        )
                      : null;

                  await _mapController!.setMapStyle(style);
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
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
