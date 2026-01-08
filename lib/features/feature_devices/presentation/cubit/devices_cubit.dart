import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_tracking/core/errors/show_snack_bar.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  final GetDevicesList getDevicesList;

  final List<DeviceEntity> _allDevices = [];

  DeviceEntity? selectedDevice;

  DevicesCubit(this.getDevicesList) : super(DevicesInitial());

  //==========================================================
  // fetchDevices
  Future<void> fetchDevices() async {
    // emit(DevicesLoading());

    try {
      final devices = await getDevicesList();
      _allDevices.clear();
      _allDevices.addAll(devices);
      emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
    } catch (e) {
      final String errorMessage = ApiErrorHandler.handle(e);
      emit(DevicesError(errorMessage));
    }
  }

  //==========================================================
  // addDevice
  void addDevice(DeviceEntity device) {
    _allDevices.add(device);
    emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
  }

  //==========================================================
  // searchDevices
  void searchDevices(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
      return;
    }
    
    final filtered = _allDevices.where((device) {
      return device.brand.toLowerCase().contains(q) ||
          device.model.toLowerCase().contains(q) ||
          device.plateNumber.toLowerCase().contains(q) ||
          device.status.toLowerCase().contains(q);
    }).toList();

    emit(DevicesLoaded(filtered, selectedDevice, DateTime.now()));
  }

  //==========================================================
  // searchDevicesList
  void searchDevicesList(String query) {
    emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
  }

  //==========================================================
  // clearSearch
  void clearSearch() {
    emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
  }

  //==========================================================
  // selectDevice
  void selectDevice(DeviceEntity device) {
    selectedDevice = device;
    emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
  }

  //==========================================================
  // getMarkers
  Set<Marker> getMarkers() {
    return _allDevices.where((device) => device.lastRecord != null).map((
      device,
    ) {
      final record = device.lastRecord!;
      return Marker(
        markerId: MarkerId(device.id),
        position: LatLng(record.lat, record.lng),
        infoWindow: InfoWindow(title: device.brand),
      );
    }).toSet();
  }

  //==========================================================
  // updateDeviceInList
  void updateDeviceInList(DeviceEntity updatedDevice) {
    final index = _allDevices.indexWhere((d) => d.id == updatedDevice.id);
    if (index != -1) {
      _allDevices[index] = updatedDevice;
      
      if (selectedDevice?.id == updatedDevice.id) {
        selectedDevice = updatedDevice;
      }
    
      emit(DevicesLoaded(List.of(_allDevices), selectedDevice, DateTime.now()));
    }
  }

  //==========================================================
  // deleteDeviceFromList
  void deleteDeviceFromList(String deviceId) {
    _allDevices.removeWhere((device) => device.id == deviceId);
    emit(DevicesLoaded(List.from(_allDevices), selectedDevice, DateTime.now()));
  }
}
