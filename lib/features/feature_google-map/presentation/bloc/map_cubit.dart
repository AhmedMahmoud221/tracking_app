import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/features/feature_google-map/domain/entities/vehicle_map.dart';
import 'package:live_tracking/features/feature_google-map/domain/usecases/get_device_map.dart';

class MapState {
  final List<Device> devices;
  final Device? selected;
  final bool loading;
  final String? error;

  MapState({
    required this.devices,
    this.selected,
    this.loading = false,
    this.error,
  });

  MapState copyWith({
    List<Device>? devices,
    Device? selected,
    bool? loading,
    String? error,
  }) {
    return MapState(
      devices: devices ?? this.devices,
      selected: selected ?? this.selected,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class MapCubit extends Cubit<MapState> {
  final GetDevices getDevices;

  MapCubit({required this.getDevices})
    : super(MapState(devices: [], loading: false));

  // تحميل الأجهزة
  Future<void> loadDevices() async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final list = await getDevices();
      emit(state.copyWith(devices: list, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  // اختيار جهاز
  void selectDevice(Device device) {
    emit(state.copyWith(selected: device));
  }

  void clearSelection() {
    emit(state.copyWith(selected: null));
  }

  // انشاء Markers
  Set<Marker> getMarkers() {
    return state.devices.map((d) {
      return Marker(
        markerId: MarkerId(d.id.toString()),
        position: LatLng(d.lat, d.lng),
        infoWindow: InfoWindow(title: d.name),
      );
    }).toSet();
  }

  // تحريك الكاميرا
  Future<void> moveCamera(
    GoogleMapController? controller,
    Device device,
  ) async {
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(device.lat, device.lng), zoom: 17),
      ),
    );
  }
}
