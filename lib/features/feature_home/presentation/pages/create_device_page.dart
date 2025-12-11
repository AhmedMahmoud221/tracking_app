import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_state.dart';

class CreateDevicePage extends StatefulWidget {
  @override
  State<CreateDevicePage> createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final _formKey = GlobalKey<FormState>();

  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final plateController = TextEditingController();

  String selectedType = "Car";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(179, 214, 246, 255),
        title: Text(
          "Create Device"
        ),
      ),

      body: BlocListener<CreateDeviceCubit, CreateDeviceState>(
        listener: (context, state) {
          if (state is CreateDeviceSuccess) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
            brandController.clear();
            modelController.clear();
            yearController.clear();
            plateController.clear();
            setState(() {
              selectedType = "Car";
            });

            context.read<DevicesCubit>().addDevice(state.device);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Device Created Successfully")),
            );

            if (context.canPop()) {
              context.pop(true);
            }
          }

          if (state is CreateDeviceError) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 12,),
                  
                        TextFormField(
                          controller: brandController,
                          decoration: InputDecoration(
                            labelText: "Brand",
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: Colors.grey, // هنا تختار اللون اللي تحبه
                              fontWeight: FontWeight.w500, // اختياري لو عايز سمك مختلف
                              fontSize: 16, // اختياري لو عايز حجم مختلف
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                  
                        const SizedBox(height: 12,),
                        TextFormField(
                          controller: brandController,
                          decoration: InputDecoration(
                            labelText: "Model",
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: Colors.grey, // هنا تختار اللون اللي تحبه
                              fontWeight: FontWeight.w500, // اختياري لو عايز سمك مختلف
                              fontSize: 16, // اختياري لو عايز حجم مختلف
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                  
                        const SizedBox(height: 12,),
                        TextFormField(
                          controller: brandController,
                          decoration: InputDecoration(
                            labelText: "Year",
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: Colors.grey, // هنا تختار اللون اللي تحبه
                              fontWeight: FontWeight.w500, // اختياري لو عايز سمك مختلف
                              fontSize: 16, // اختياري لو عايز حجم مختلف
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                          keyboardType: TextInputType.number,
                        ),
                  
                        const SizedBox(height: 12,),
                        TextFormField(
                          controller: brandController,
                          decoration: InputDecoration(
                            labelText: "Plate Number",
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: Colors.grey, // هنا تختار اللون اللي تحبه
                              fontWeight: FontWeight.w500, // اختياري لو عايز سمك مختلف
                              fontSize: 16, // اختياري لو عايز حجم مختلف
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                  
                        const SizedBox(height: 12,),
                        DropdownButtonFormField2<String>(
                          value: null, // null عشان يظهر placeholder بدل القيمة الافتراضية
                          decoration: InputDecoration(
                            // labelText: "Type", // كلمة placeholder
                            filled: true,
                            fillColor: Colors.grey[100], // خلفية رمادية للحقل
                            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          isExpanded: false,
                          hint: const Text(
                            "Type", // placeholder
                            style: TextStyle(color: Colors.grey),
                          ),
                          items: ["Car", "Motorcycle", "Truck"]
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12), // ريدياس للقائمة
                              color: Colors.grey[100], // خلفية بيضاء
                            ),
                            elevation: 4,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedType = value!;
                            });
                          },
                        ),
                  
                        SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final device = DeviceEntity(
                            id: "",
                            brand: brandController.text,
                            model: modelController.text,
                            year: int.parse(yearController.text),
                            plateNumber: plateController.text,
                            type: selectedType,
                            user: "",
                            status: "",
                            speed: 0,
                            lastLocation: LastLocationEntity(
                              type: "",
                              coordinates: [],
                            ),
                          );
                                      
                          context.read<CreateDeviceCubit>().createDevice(device);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                        backgroundColor: const Color.fromARGB(255, 96, 182, 253),
                        elevation: 4,
                      ),
                      child: Text("Create Device", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
