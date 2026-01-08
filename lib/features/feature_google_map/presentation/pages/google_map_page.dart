import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/extensions/status_localization_extension.dart';
import 'package:live_tracking/core/socketService/socket_service.dart';
import 'package:live_tracking/core/utils/secure_storage.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_google_map/presentation/socket_cubit/map_socket_cubit.dart';
import 'package:live_tracking/features/feature_google_map/presentation/socket_cubit/map_socket_state.dart';
import 'package:live_tracking/features/feature_google_map/presentation/widgets/custom_bottom_sheet.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';
import 'package:live_tracking/features/feature_google_map/presentation/widgets/device_details_popup.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/device_details_page.dart';
import 'package:live_tracking/l10n/app_localizations.dart';
import 'package:live_tracking/main.dart';

class GoogleMapPage extends StatefulWidget {
  final DeviceEntity? initialDevice;
  const GoogleMapPage({super.key, this.initialDevice});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late final Completer<GoogleMapController> _controllerCompleter;
  GoogleMapController? _mapController;

  final Map<String, Marker> _deviceMarkers = {};
  // final Map<String, List<LatLng>> _devicePaths = {};
  // final Map<String, Polyline> _polylines = {};

  BitmapDescriptor? _customMarker;

  bool _socketConnected = false;

  @override
  void initState() {
    super.initState();
    _controllerCompleter = Completer();

    _loadCustomMarker();

    final initialDevice = widget.initialDevice;
    if (initialDevice != null) {
      context.read<DevicesCubit>().selectDevice(initialDevice);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _waitForMarkerLoad();
        _initializeMarkersAndPaths([initialDevice]);

        if (initialDevice.lastRecord != null) {
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                initialDevice.lastRecord!.lat,
                initialDevice.lastRecord!.lng,
              ),
            ),
          );
        }
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _waitForMarkerLoad();
        context.read<DevicesCubit>().fetchDevices();
      });
    }

    _connectSocketWithToken();
  }

  Future<void> _waitForMarkerLoad() async {
    while (_customMarker == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<void> _loadCustomMarker() async {
    final marker = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(64, 64)),
      'assets/images/Simplification_2.png',
    );

    if (!mounted) return;

    setState(() {
      _customMarker = marker;
    });
  }

  Future<void> _connectSocketWithToken() async {
    if (_socketConnected) return;

    try {
      final token = await SecureStorage.readToken();

      if (token != null && token.isNotEmpty) {
        if (mounted) {
          // 1. تشغيل المحرك الرئيسي (السوكيت الموحد)
          sl<SocketService>().init(token);

          // 2. تفعيل الاستماع في كيوبت الماب
          context.read<MapSocketCubit>().listenToLocation();

          _socketConnected = true;
          debugPrint('💡 Socket Connection: Initialized and Map is listening.');
        }
      } else {
        debugPrint('❌ Socket Connection: Token not found.');
      }
    } catch (e) {
      debugPrint('❌ Error connecting socket: $e');
    }
  }

  void _initializeMarkersAndPaths(List<DeviceEntity> devices) {
    setState(() {
      _deviceMarkers.clear();
      // _devicePaths.clear();
      // _polylines.clear();

      for (final device in devices) {
        final deviceId = device.id;
        final record = device.lastRecord;

        // لو الجهاز لسه ما بعتش موقع
        if (record == null) continue;

        final lat = record.lat;
        final lng = record.lng;
        final initialPos = LatLng(lat, lng);

        _deviceMarkers[deviceId] = Marker(
          markerId: MarkerId(deviceId),
          position: initialPos,
          rotation: record.rotation,
          anchor: const Offset(0.5, 0.5),
          flat: true,
          icon: _customMarker ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: device.model,
            snippet:
                '${AppLocalizations.of(context)!.status} : ${record.status.localized(context)}',
          ),
          onTap: () {
            context.read<DevicesCubit>().selectDevice(device);
            _showDeviceDetails(device);
          },
        );

        // _devicePaths[deviceId] = [initialPos];

        // _polylines[deviceId] = Polyline(
        //   polylineId: PolylineId(deviceId),
        //   points: _devicePaths[deviceId]!,
        //   color: Colors.blueAccent,
        //   width: 4,
        // );
      }
    });

    final selectedDevice = context.read<DevicesCubit>().state is DevicesLoaded 
      ? (context.read<DevicesCubit>().state as DevicesLoaded).selectedDevice 
      : widget.initialDevice;

    if (selectedDevice?.lastRecord != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(selectedDevice!.lastRecord!.lat, selectedDevice.lastRecord!.lng),
        ),
      );
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

  void _updateDeviceLocation(dynamic data) {
    final deviceId = data['deviceId']?.toString();
    final lat = data['lat'];
    final lng = data['lng'];
    final speed = data['speed'] ?? 0;
    final double rotation = (data['rotation'] ?? 0.0).toDouble();

    if (deviceId == null || lat == null || lng == null) return;

    final newPos = LatLng(lat, lng);

    if (!_deviceMarkers.containsKey(deviceId)) {
      debugPrint('Update received for unknown device ID: $deviceId');
      return;
    }

    setState(() {
      // _devicePaths.putIfAbsent(deviceId, () => []);
      // _devicePaths[deviceId]!.add(newPos);

      // _polylines[deviceId] = Polyline(
      //   polylineId: PolylineId(deviceId),
      //   points: _devicePaths[deviceId]!,
      //   color: Colors.blueAccent,
      //   width: 4,
      // );

      final oldMarker = _deviceMarkers[deviceId]!;

      String deviceName = 'Device $deviceId';
      final devicesState = context.read<DevicesCubit>().state;
      if (devicesState is DevicesLoaded) {
        final foundDevice = devicesState.devices
            .where((d) => d.id == deviceId)
            .firstOrNull;

        if (foundDevice != null) {
          deviceName = foundDevice.id;
        }
      }

      _deviceMarkers[deviceId] = oldMarker.copyWith(
        positionParam: newPos,
        rotationParam: rotation,
        anchorParam: const Offset(0.5, 0.5),
        flatParam: true,
        iconParam: _customMarker,
        infoWindowParam: InfoWindow(
          title: deviceName,
          snippet: '${AppLocalizations.of(context)!.speed} : $speed km/h',
        ),
      );
    });

    final selectedDevice = context.read<DevicesCubit>().state is DevicesLoaded
        ? (context.read<DevicesCubit>().state as DevicesLoaded).selectedDevice
        : null;

    if (selectedDevice?.id == deviceId) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(newPos));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeState.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setMapStyle(isDark);
    });

    return MultiBlocListener(
      listeners: [
        BlocListener<MapSocketCubit, MapSocketState>(
          listener: (context, state) {
            if (state is MapSocketLocationUpdated) {
              _updateDeviceLocation(state.data);
            }
          },
        ),

        BlocListener<DevicesCubit, DevicesState>(
          listener: (context, state) async {
            if (state is DevicesLoaded) {
              if (widget.initialDevice == null) {
                _initializeMarkersAndPaths(state.devices);
              }

              final record = state.selectedDevice?.lastRecord;
              if (record != null) {
                await _mapController?.animateCamera(
                  CameraUpdate.newLatLng(LatLng(record.lat, record.lng)),
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<DevicesCubit, DevicesState>(
        builder: (context, state) {
          List<DeviceEntity> devices = [];
          bool loading = false;
          if (state is DevicesLoading) loading = true;
          if (state is DevicesLoaded) devices = state.devices;

          final initialPosition = widget.initialDevice?.lastRecord != null
              ? LatLng(
                  widget.initialDevice!.lastRecord!.lat,
                  widget.initialDevice!.lastRecord!.lng,
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
                  markers: _deviceMarkers.values.toSet(),
                  // polylines: _polylines.values.toSet(),
                  onMapCreated: (controller) {
                    _mapController = controller;
                    if (!_controllerCompleter.isCompleted) {
                      _controllerCompleter.complete(controller);
                    }
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
      ),
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
            Navigator.pop(context);
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
