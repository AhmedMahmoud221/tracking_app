// import 'package:flutter/material.dart';

// class AddVehiclePage extends StatefulWidget {
//   const AddVehiclePage({super.key});

//   @override
//   State<AddVehiclePage> createState() => _AddVehiclePageState();
// }

// class _AddVehiclePageState extends State<AddVehiclePage> {
//   final _formKey = GlobalKey<FormState>();
//   final ImagePicker picker = ImagePicker();

//   File? vehicleImage;

//   final TextEditingController brandController = TextEditingController();
//   final TextEditingController modelController = TextEditingController();
//   final TextEditingController yearController = TextEditingController();
//   final TextEditingController platNumberController = TextEditingController();
//   final TextEditingController deviceIdController = TextEditingController();

//   String? typeValue;
//   String? statusValue;

//   final List<String> types = ["Car", "Truck", "Motorbike"];
//   final List<String> statuses = ["parking", "moving", "on", "off"];

//   Future<void> pickImage() async {
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         vehicleImage = File(image.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       // appBar: AppBar(
//       //   title: const Text("Add Vehicle"),
//       //   centerTitle: true,
//       //   elevation: 0,
//       //   backgroundColor: Colors.transparent,
//       //   foregroundColor: Colors.black,
//       // ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Image Picker
//               GestureDetector(
//                 onTap: pickImage,
//                 child: Container(
//                   height: 200,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.shade300),
//                   ),
//                   child: vehicleImage != null
//                       ? ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: Image.file(vehicleImage!, fit: BoxFit.cover),
//                         )
//                       : const Center(
//                           child: Icon(
//                             Icons.camera_alt,
//                             size: 60,
//                             color: Colors.grey,
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Text Fields
//               _buildTextField(controller: brandController, label: "Brand"),
//               _buildTextField(controller: modelController, label: "Model"),
//               _buildTextField(
//                 controller: yearController,
//                 label: "Year",
//                 keyboard: TextInputType.number,
//               ),
//               _buildTextField(
//                 controller: platNumberController,
//                 label: "Plate Number",
//               ),
//               _buildDropdown(
//                 label: "Type",
//                 value: typeValue,
//                 items: types,
//                 onChanged: (v) => setState(() => typeValue = v),
//               ),
//               _buildDropdown(
//                 label: "Status",
//                 value: statusValue,
//                 items: statuses,
//                 onChanged: (v) => setState(() => statusValue = v),
//               ),
//               _buildTextField(
//                 controller: deviceIdController,
//                 label: "Device ID",
//               ),

//               const SizedBox(height: 30),

//               // Save Button
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     backgroundColor: Colors.blueAccent,
//                   ),
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("Vehicle Added Successfully!"),
//                         ),
//                       );
//                     }
//                   },
//                   child: const Text(
//                     "Add Vehicle",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     TextInputType keyboard = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboard,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 18,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         validator: (value) =>
//             value == null || value.isEmpty ? "Please enter $label" : null,
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String label,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: DropdownButtonFormField<String>(
//         value: value,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           floatingLabelBehavior: FloatingLabelBehavior.always,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 18,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         items: items
//             .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//             .toList(),
//         onChanged: onChanged,
//         validator: (value) =>
//             value == null || value.isEmpty ? "Please select $label" : null,
//       ),
//     );
//   }
// }
