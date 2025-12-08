// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
// import 'package:live_tracking/features/feature_devices/presentation/bloc/devices_state.dart';

// class DevicesCubit extends Cubit<DevicesState> {
//   final GetDevicesList getDevicesList;

//   DevicesCubit(this.getDevicesList) : super(DevicesState.initial());

//   void loadDevices() async {
//     emit(state.copyWith(loading: true, error: null));
//     try {
//       final devices = await getDevicesList();
//       emit(
//         state.copyWith(
//           loading: false,
//           devices: devices,
//           filteredDevices: devices,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(loading: false, error: e.toString()));
//     }
//   }

//   void searchDevices(String query) {
//     final results = state.devices.where((device) {
//       final input = query.toLowerCase();
//       return device.name.toLowerCase().contains(input) ||
//           device.model.toLowerCase().contains(input);
//     }).toList();

//     emit(state.copyWith(filteredDevices: results));
//   }
// }
