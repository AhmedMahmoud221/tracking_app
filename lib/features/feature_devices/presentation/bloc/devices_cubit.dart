import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
import 'package:live_tracking/features/feature_devices/presentation/bloc/devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  final GetDevicesList getDevicesList;

  final List<DeviceEntity> allDevices = [];

  // خزّن هنا كل الأجهزة اللي جت من الـ API عشان نقدر نفلتر بسهولة
  final List<DeviceEntity> _allDevices = [];

  DevicesCubit(this.getDevicesList) : super(DevicesInitial());

  Future<void> fetchDevices() async {
    emit(DevicesLoading());

    try {
      final devices = await getDevicesList();
      // خزّن النسخة الأصلية
      _allDevices.clear();
      _allDevices.addAll(devices);
      emit(DevicesLoaded(List.from(_allDevices)));
      emit(DevicesLoaded(devices));
    } catch (e) {
      emit(DevicesError(e.toString()));
    }
  }

  void searchDevices(String query) {
  final filtered = allDevices.where(
    (device) => device.model.toLowerCase().contains(query.toLowerCase()),
  ).toList();

  emit(DevicesLoaded(filtered));
  }

 /// فلترة محلية على _allDevices
  void searchDevicesList(String query) {
    final q = query.trim();

    // لو البحث فاضي رجّع القائمة الأصلية
    if (q.isEmpty) {
      emit(DevicesLoaded(List.from(_allDevices)));
      return;
    }

    // فلترة آمنة — نتاكد إننا نعمل toLowerCase على السلاسل قبل المقارنة
    final filtered = _allDevices.where((device) {
      final brand = device.brand.toLowerCase();
      final model = device.model.toLowerCase();
      final plate = device.plateNumber.toLowerCase();
      final status = device.status.toLowerCase();
      final lowerQ = q.toLowerCase();

      return brand.contains(lowerQ) ||
             model.contains(lowerQ) ||
             plate.contains(lowerQ) ||
             status.contains(lowerQ);
    }).toList();

    emit(DevicesLoaded(filtered));
  }

  /// لو احتجت تعمل إعادة تحميل / مسح فلتر
  void clearSearch() {
    emit(DevicesLoaded(List.from(_allDevices)));
  }
}
