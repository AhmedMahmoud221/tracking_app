import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
import 'devices_map_state.dart';

class DevicesMapCubit extends Cubit<DevicesMapState> {
  final GetDevicesList getDevicesList;

  DevicesMapCubit(this.getDevicesList) : super(DevicesInitial());

  List<DeviceEntity> _devices = [];
  DeviceEntity? _selected;

  /// تهيئة الأجهزة من الـ DevicesCubit
  void setDevices(List<DeviceEntity> devices) {
    _devices.clear();
    _devices.addAll(devices);
    emit(DevicesLoaded(devices: _devices));
  }

  void addDevice(DeviceEntity device) {
    _devices.add(device);
    emit(DevicesLoaded(devices: _devices));
  }

  Future<void> loadDevices() async {
    emit(DevicesLoading());

    try {
      _devices = await getDevicesList();
      emit(DevicesLoaded(devices: _devices));
    } catch (e) {
      emit(DevicesError(e.toString()));
    }
  }

  void selectDevice(DeviceEntity device) {
    _selected = device;
    emit(DevicesLoaded(devices: _devices, selected: _selected));
  }

  Set<Marker> getMarkers() {
    return _devices.map((device) {
      final coords = device.lastLocation.coordinates;
      return Marker(
        markerId: MarkerId(device.id),
        position: LatLng(coords[1], coords[0]), // latitude, longitude
        infoWindow: InfoWindow(title: device.brand),
      );
    }).toSet();
  }

  Future<void> moveCamera(
    GoogleMapController? controller,
    DeviceEntity device,
  ) async {
    if (controller == null) return;

    final coords = device.lastLocation.coordinates;
    await controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(coords[1], coords[0])),
    );
  }
}
