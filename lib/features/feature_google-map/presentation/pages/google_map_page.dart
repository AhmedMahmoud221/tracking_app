import 'package:flutter/material.dart';

class GoogleMapPage extends StatelessWidget {
  const GoogleMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('data'),
    );
  }
}




// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:live_tracking/features/feature_google-map/presentation/widgets/custom_bottom_sheet.dart';
// import '../bloc/map_cubit.dart';

// class GoogleMapPage extends StatefulWidget {
//   const GoogleMapPage({super.key});

//   @override
//   State<GoogleMapPage> createState() => _GoogleMapPageState();
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   late final Completer<GoogleMapController> _controllerCompleter;
//   GoogleMapController? _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _controllerCompleter = Completer<GoogleMapController>();
//     // load devices via cubit
//     context.read<MapCubit>().loadDevices();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MapCubit, MapState>(
//       listener: (context, state) async {
//         if (state.selected != null) {
//           // move camera when a device is selected
//           await context.read<MapCubit>().moveCamera(
//             _mapController,
//             state.selected!,
//           );
//         }
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: BlocBuilder<MapCubit, MapState>(
//             builder: (context, state) {
//               if (state.loading && state.devices.isEmpty) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final markers = context.read<MapCubit>().getMarkers();

//               return Stack(
//                 children: [
//                   GoogleMap(
//                     initialCameraPosition: const CameraPosition(
//                       target: LatLng(30.0, 31.0),
//                       zoom: 12,
//                     ),
//                     markers: markers,
//                     onMapCreated: (controller) {
//                       if (!_controllerCompleter.isCompleted) {
//                         _controllerCompleter.complete(controller);
//                       }
//                       _mapController = controller;
//                     },
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 20,
//                     child: CustomBottomSheet(
//                       devices: state.devices,
//                       onSelect: (device) {
//                         context.read<MapCubit>().selectDevice(device);
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
