// // lib/features/feature_devices/presentation/bloc/devices_cubit.dart
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
// import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';

// class DevicesState {
//   final List<DeviceEntity> devices;
//   final List<DeviceEntity> filteredDevices;
//   final bool loading;
//   final String? error;

//   DevicesState({
//     required this.devices,
//     required this.filteredDevices,
//     required this.loading,
//     this.error,
//   });

//   factory DevicesState.initial() {
//     return DevicesState(
//       devices: [],
//       filteredDevices: [],
//       loading: false,
//       error: null,
//     );
//   }

//   DevicesState copyWith({
//     List<DeviceEntity>? devices,
//     List<DeviceEntity>? filteredDevices,
//     bool? loading,
//     String? error, // قد يمرر null صراحة لتمسح الخطأ
//   }) {
//     return DevicesState(
//       devices: devices ?? this.devices,
//       filteredDevices: filteredDevices ?? this.filteredDevices,
//       loading: loading ?? this.loading,
//       // إذا المستخدم مرر null بصراحة يبقى نعالجها هنا بحيث نحتفظ بالقيمة القديمة
//       error: error ?? this.error,
//     );
//   }
// }

// class DevicesCubit extends Cubit<DevicesState> {
//   final GetDevicesList getDevicesUseCase;

//   DevicesCubit(this.getDevicesUseCase) : super(DevicesState.initial());

//   void loadDevices() async {
//     emit(state.copyWith(loading: true, error: null));
//     try {
//       final devices = await getDevicesUseCase();
//       emit(
//         state.copyWith(
//           loading: false,
//           devices: devices,
//           filteredDevices: devices,
//           error: null,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(loading: false, error: e.toString()));
//     }
//   }

//   void searchDevices(String query) {
//     final results = state.devices.where((device) {
//       final name = device.name.toLowerCase();
//       final model = device.model.toLowerCase();
//       final input = query.toLowerCase();
//       return name.contains(input) || model.contains(input);
//     }).toList();

//     emit(state.copyWith(filteredDevices: results));
//   }
// }
