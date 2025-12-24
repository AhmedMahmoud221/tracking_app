import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/user_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubit/create_device_state.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final _formKey = GlobalKey<FormState>();
  final brandController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final plateController = TextEditingController();
  String selectedType = "Car";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState == ThemeState.dark;

        final backgroundColor = isDark ? Colors.black : Colors.white;
        final fieldFillColor = isDark ? Colors.grey[850] : Colors.grey[100];
        final fieldTextColor = isDark ? Colors.white : Colors.black;
        final fieldLabelColor = isDark ? Colors.white70 : Colors.grey;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            iconTheme: IconThemeData(color: fieldTextColor),
            title: Text(
              "${AppLocalizations.of(context)!.createdevice}",
              style: TextStyle(color: fieldTextColor),
            ),
          ),
          body: BlocListener<CreateDeviceCubit, CreateDeviceState>(
            listener: (context, state) {
              if (state is CreateDeviceSuccess) {
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();

                brandController.clear();
                modelController.clear();
                yearController.clear();
                plateController.clear();
                setState(() {
                  selectedType = "Car";
                });

                context.read<DevicesCubit>().addDevice(state.device);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Device Created Successfully")),
                );

                if (context.canPop()) context.pop(true);
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
                            const SizedBox(height: 12),

                            // Brand
                            TextFormField(
                              controller: brandController,
                              decoration: InputDecoration(
                                labelText:
                                    "${AppLocalizations.of(context)!.brand}",
                                filled: true,
                                fillColor: fieldFillColor,
                                labelStyle: TextStyle(
                                  color: fieldLabelColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: fieldTextColor),
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 12),

                            // Model
                            TextFormField(
                              controller: modelController,
                              decoration: InputDecoration(
                                labelText:
                                    "${AppLocalizations.of(context)!.model}",
                                filled: true,
                                fillColor: fieldFillColor,
                                labelStyle: TextStyle(
                                  color: fieldLabelColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: fieldTextColor),
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 12),

                            // Year
                            TextFormField(
                              controller: yearController,
                              decoration: InputDecoration(
                                labelText:
                                    "${AppLocalizations.of(context)!.year}",
                                filled: true,
                                fillColor: fieldFillColor,
                                labelStyle: TextStyle(
                                  color: fieldLabelColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: fieldTextColor),
                              validator: (v) => v!.isEmpty ? "Required" : null,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),

                            // Plate Number
                            TextFormField(
                              controller: plateController,
                              decoration: InputDecoration(
                                labelText:
                                    "${AppLocalizations.of(context)!.platenumber}",
                                filled: true,
                                fillColor: fieldFillColor,
                                labelStyle: TextStyle(
                                  color: fieldLabelColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: fieldTextColor),
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 12),

                            // Dropdown Type
                            DropdownButtonFormField2<String>(
                              value: null,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: fieldFillColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              hint: Text(
                                "${AppLocalizations.of(context)!.type}",
                                style: TextStyle(color: fieldLabelColor),
                              ),
                              items:
                                  [
                                        "${AppLocalizations.of(context)!.car}",
                                        "${AppLocalizations.of(context)!.motorcycle}",
                                        "${AppLocalizations.of(context)!.truck}",
                                      ]
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              color: fieldTextColor,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isDark
                                      ? Colors.grey[850]
                                      : Colors.white,
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),

                    // Create Button
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
                                user: UserEntity(id: '', name: '', email: ''),
                                status: "",
                                //speed: 0,
                                lastRecord: null,
                              );

                              context.read<CreateDeviceCubit>().createDevice(
                                device,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue,
                            elevation: 4,
                          ),
                          child: Text(
                            '${AppLocalizations.of(context)!.createdevice}',
                            style: TextStyle(color: Colors.white, fontSize: 18),
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
      },
    );
  }
}
