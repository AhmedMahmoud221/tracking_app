// import 'package:flutter/material.dart';
// import 'package:live_tracking/features/feature_google-map/domain/entities/vehicle_map.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// class CustomBottomSheet extends StatelessWidget {
//   final List<Device> devices;
//   final void Function(Device) onSelect;

//   const CustomBottomSheet({
//     super.key,
//     required this.devices,
//     required this.onSelect,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         showMaterialModalBottomSheet(
//           context: context,
//           backgroundColor: Colors.transparent,
//           builder: (context) {
//             return Container(
//               height: 520,
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//               ),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 45,
//                     height: 5,
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'Devices',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                   Expanded(
//                     child: ListView.separated(
//                       itemCount: devices.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 10),
//                       itemBuilder: (context, index) {
//                         final d = devices[index];
//                         final online = d.status == 'online';
//                         return InkWell(
//                           onTap: () {
//                             Navigator.pop(context); // close sheet
//                             onSelect(d);
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 14,
//                               horizontal: 12,
//                             ),
//                             margin: EdgeInsets.zero,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.location_on_outlined,
//                                   size: 32,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Text(
//                                     d.name,
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 12,
//                                       height: 12,
//                                       decoration: BoxDecoration(
//                                         color: online
//                                             ? Colors.green
//                                             : Colors.red,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(width: 8),
//                                     Text(
//                                       online ? 'Online' : 'Offline',
//                                       style: TextStyle(
//                                         color: online
//                                             ? Colors.green
//                                             : Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.blue,
//           borderRadius: BorderRadius.circular(40),
//         ),
//         child: const Icon(Icons.car_rental, color: Colors.white),
//       ),
//     );
//   }
// }
