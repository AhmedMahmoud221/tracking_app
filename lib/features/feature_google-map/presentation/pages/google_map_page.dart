import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_google-map/presentation/cubit/devices_map_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/cubit/devices_map_state.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/custom_bottom_sheet.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

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
    context.read<DevicesMapCubit>().loadDevices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DevicesMapCubit, DevicesMapState>(
      listener: (context, state) async {
        if (state is DevicesLoaded && state.selected != null) {
          await context.read<DevicesMapCubit>().moveCamera(
            _mapController,
            state.selected!,
          );
        }
      },
      builder: (context, state) {
        List<DeviceEntity> devices = [];
        bool loading = false;

        if (state is DevicesLoading) {
          loading = true;
        } else if (state is DevicesLoaded) {
          devices = state.devices;
        }

        final markers = context.read<DevicesMapCubit>().getMarkers();

        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(30.0, 31.0),
                  zoom: 12,
                ),
                markers: markers,
                onMapCreated: (controller) {
                  if (!_controllerCompleter.isCompleted) {
                    _controllerCompleter.complete(controller);
                  }
                  _mapController = controller;
                },
              ),
              if (loading) const Center(child: CircularProgressIndicator()),
              Positioned(
                bottom: 20,
                left: 20,
                child: CustomBottomSheet(
                  devices: devices,
                  onSelect: (device) {
                    context.read<DevicesMapCubit>().selectDevice(device);
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
