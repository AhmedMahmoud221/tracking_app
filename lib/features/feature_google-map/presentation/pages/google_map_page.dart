import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/utils/storage_helper.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/socket_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/socket_cubit/socket_state.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/custom_bottom_sheet.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/device_details_popup.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/device_details_page.dart';

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
  final Map<String, List<LatLng>> _devicePaths = {};
  final Map<String, Polyline> _polylines = {};

  bool _socketConnected = false;

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

    // 💡 الخطوة الجديدة: جلب التوكن والاتصال بالـ Socket
    _connectSocketWithToken();
  }

  // في ملف google_map_page.dart، داخل دالة _connectSocketWithToken()

Future<void> _connectSocketWithToken() async {
  if (_socketConnected) return;

  try {
    // 💡 الآن نستخدم دالة readToken() الثابتة من الكلاس SecureStorage
    final token = await SecureStorage.readToken(); 

    if (token != null && token.isNotEmpty) {
      if (mounted) {
        context.read<SocketCubit>().connect(token);
        _socketConnected = true;
        debugPrint('💡 Socket Connection Attempt: Started successfully with token.');
      }
    } else {
      debugPrint('❌ Socket Connection Attempt: Token not found in Secure Storage.');
    }
  } catch (e) {
    debugPrint('❌ Error reading token or connecting socket: $e');
  }
}
  
  void _initializeMarkersAndPaths(List<DeviceEntity> devices) {
    if (_deviceMarkers.isNotEmpty) return; 

    setState(() {
      _deviceMarkers.clear();
      _devicePaths.clear();
      _polylines.clear();
      
      for (final device in devices) {
        final deviceId = device.id;
        final lat = device.lastLocation.coordinates[1];
        final lng = device.lastLocation.coordinates[0];
        final initialPos = LatLng(lat, lng);
        
        _deviceMarkers[deviceId] = Marker(
          markerId: MarkerId(deviceId),
          position: initialPos,
          // 💡 هنا استخدمنا `device.name` بناءً على تصحيحك السابق
          infoWindow: InfoWindow(
            title: device.model,
            snippet: 'Status: ${device.status}',
          ),
          onTap: () {
            context.read<DevicesCubit>().selectDevice(device);
            _showDeviceDetails(device);
          },
        );

        _devicePaths[deviceId] = [initialPos];
        
        _polylines[deviceId] = Polyline(
          polylineId: PolylineId(deviceId),
          points: _devicePaths[deviceId]!,
          color: Colors.blueAccent,
          width: 4,
        );
      }
    });
  }

  Future<void> _setMapStyle(bool isDark) async {
    if (_mapController == null) return;
    final style = isDark
        ? await DefaultAssetBundle.of(context)
            .loadString('assets/google_map_theme/dark_map_style.json')
        : null;
    await _mapController!.setMapStyle(style);
  }

  void _updateDeviceLocation(dynamic data) {
    final deviceId = data['deviceId']?.toString(); 
    final lat = data['lat'];
    final lng = data['lng'];
    final speed = data['speed'] ?? 0;

    if (deviceId == null || lat == null || lng == null) return;

    final newPos = LatLng(lat, lng);

    if (!_deviceMarkers.containsKey(deviceId)) {
        debugPrint('Update received for unknown device ID: $deviceId');
        return;
    }

    setState(() {
      _devicePaths.putIfAbsent(deviceId, () => []);
      _devicePaths[deviceId]!.add(newPos);

      _polylines[deviceId] = Polyline(
        polylineId: PolylineId(deviceId),
        points: _devicePaths[deviceId]!,
        color: Colors.blueAccent,
        width: 4,
      );

      final oldMarker = _deviceMarkers[deviceId]!;
      
      String deviceName = 'Device $deviceId';
      final devicesState = context.read<DevicesCubit>().state;
      if (devicesState is DevicesLoaded) {
          // 💡 تم استخدام firstOrNull لتجنب خطأ orElse المعقد
          final foundDevice = devicesState.devices
              .where((d) => d.id == deviceId)
              .firstOrNull; 

          if (foundDevice != null) {
              // 💡 الآن نعتمد على أن 'name' موجودة في DeviceEntity
              deviceName = foundDevice.id; 
          }
      }

      _deviceMarkers[deviceId] = oldMarker.copyWith(
        positionParam: newPos, 
        infoWindowParam: InfoWindow(
          title: deviceName,
          snippet: 'Speed: $speed km/h',
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
        // 💡 تم حذف BlocListener<AuthCubit, AuthState> واستبداله بـ _connectSocketWithToken في initState

        // 1. استماع لـ SocketCubit لتحديث الموقع
        BlocListener<SocketCubit, SocketState>(
          listener: (context, state) {
            if (state is SocketLocationUpdated) {
              _updateDeviceLocation(state.data);
            }
          },
        ),

        // 2. استماع لـ DevicesCubit لتهيئة العلامات وتحريك الكاميرا
        BlocListener<DevicesCubit, DevicesState>(
          listener: (context, state) async {
            if (state is DevicesLoaded) {
              _initializeMarkersAndPaths(state.devices);

              if (state.selectedDevice != null) {
                final coords = state.selectedDevice!.lastLocation.coordinates;
                await _mapController?.animateCamera(
                  CameraUpdate.newLatLng(LatLng(coords[1], coords[0])),
                );
              }
              // 🎯 الخطوة الجديدة: الانضمام إلى الغرفة فور تحميل الأجهزة
              // نجمع قائمة بـ IDs جميع الأجهزة التي تم تحميلها
              // final List<String> loadedDeviceIds = 
              //     state.devices.map((d) => d.id).toList();

              // نستدعي دالة الانضمام من SocketCubit
              // context.read<SocketCubit>().joinTrackingRoom(loadedDeviceIds);
            }
          },
        ),
      ],
      child: BlocBuilder<DevicesCubit, DevicesState>(
        builder: (context, state) {
          // ... (بقية الـ builder بدون تغيير كبير)
          List<DeviceEntity> devices = [];
          bool loading = false;
          if (state is DevicesLoading) loading = true;
          if (state is DevicesLoaded) devices = state.devices;

          final initialPosition = widget.initialDevice != null
              ? LatLng(widget.initialDevice!.lastLocation.coordinates[1],
                  widget.initialDevice!.lastLocation.coordinates[0])
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
                  polylines: _polylines.values.toSet(),
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
    // ... (هذه الدالة لم تتغير)
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