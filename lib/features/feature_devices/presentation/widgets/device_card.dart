// import 'package:flutter/material.dart';
// import 'package:live_tracking/core/utils/assets.dart';
// import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';

// class DeviceCard extends StatelessWidget {
//   final DeviceEntity device;
//   const DeviceCard({super.key, required this.device});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         //context.push(AppRouter.kGoogleMapBody, extra: device);
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         elevation: 5,
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           height: 100,
//           child: Row(
//             children: [
//               // Device Image
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(15),
//                   color: Colors.grey[300],
//                   image: const DecorationImage(
//                     image: AssetImage(
//                       AssetsData.caricon,
//                     ), // replace with device image
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),

//               // Device Info
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           device.name,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       device.model,
//                       style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
