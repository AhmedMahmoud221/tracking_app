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
      appBar: AppBar(title: Text("Create Device")),

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

            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: brandController,
                    decoration: InputDecoration(labelText: "Brand"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: modelController,
                    decoration: InputDecoration(labelText: "Model"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: yearController,
                    decoration: InputDecoration(labelText: "Year"),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  TextFormField(
                    controller: plateController,
                    decoration: InputDecoration(labelText: "Plate Number"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),

                  SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(labelText: "Type"),
                    items: ["Car", "motorcycle", "Truck"]
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) => setState(() => selectedType = v!),
                  ),

                  SizedBox(height: 25),

                  ElevatedButton(
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
                    child: Text("Create Device"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
