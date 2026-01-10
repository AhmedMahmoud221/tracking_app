import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/user_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/devices_cubit/devices_cubit.dart';
import 'package:live_tracking/core/theme/theme_cubit.dart';
import 'package:live_tracking/core/theme/theme_state.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/create_device_cubit/create_device_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/create_device_cubit/create_device_state.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/update_device_cubit/update_device_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubits/update_device_cubit/update_device_state.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class AddEditDevicePage extends StatefulWidget {
  final DeviceEntity? device;

  const AddEditDevicePage({super.key, this.device});

  bool get isEdit => device != null;

  @override
  State<AddEditDevicePage> createState() => _AddEditDevicePageState();
}

class _AddEditDevicePageState extends State<AddEditDevicePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController brandController;
  late TextEditingController modelController;
  late TextEditingController yearController;
  late TextEditingController plateController;

  String selectedType = "Car"; // القيمة البرمجية (Value)
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    brandController = TextEditingController(text: widget.device?.brand ?? '');
    modelController = TextEditingController(text: widget.device?.model ?? '');
    yearController = TextEditingController(
      text: widget.device?.year.toString() ?? '',
    );
    plateController = TextEditingController(
      text: widget.device?.plateNumber ?? '',
    );
    selectedType = widget.device?.type ?? "Car";
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        final isDark = themeState == ThemeState.dark;
        final backgroundColor = isDark ? Colors.black : Colors.white;
        final fieldFillColor = isDark ? Colors.grey[850] : Colors.grey[100];
        final fieldTextColor = isDark ? Colors.white : Colors.black;
        final fieldLabelColor = isDark ? Colors.white70 : Colors.grey;

        // قائمة الأنواع (القيمة ثابتة والنص مترجم)
        final List<Map<String, String>> deviceTypes = [
          {'id': 'Car', 'name': AppLocalizations.of(context)!.car},
          {
            'id': 'Motorcycle',
            'name': AppLocalizations.of(context)!.motorcycle,
          },
          {'id': 'Truck', 'name': AppLocalizations.of(context)!.truck},
        ];

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: fieldTextColor),
            title: Text(
              widget.isEdit
                  ? AppLocalizations.of(context)!.editdevice
                  : AppLocalizations.of(context)!.createdevice,
              style: TextStyle(color: fieldTextColor),
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<CreateDeviceCubit, CreateDeviceState>(
                listener: (context, state) {
                  if (state is CreateDeviceSuccess) {
                    context.read<DevicesCubit>().addDevice(state.device);
                    _showSnackBar(
                      AppLocalizations.of(context)!.devicecreatedsuccessfully,
                    );
                    if (context.canPop()) context.pop(true);
                  } else if (state is CreateDeviceError) {
                    _showSnackBar(state.message, isError: true);
                  }
                },
              ),
              // داخل MultiBlocListener في صفحة AddEditDevicePage
              BlocListener<UpdateDeviceCubit, UpdateDeviceState>(
                listener: (context, state) {
                  if (state is UpdateDeviceSuccess) {
                    // 1. تحديث القائمة في الـ Cubit الرئيسي فوراً
                    context.read<DevicesCubit>().updateDeviceInList(
                      state.device,
                    );

                    // 2. إظهار الرسالة
                    _showSnackBar(
                      AppLocalizations.of(context)!.deviceupdatedsuccessfully,
                    );

                    // 3. الرجوع (Pop)
                    context.pop();
                  }
                },
              ),
            ],
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
                            _buildImagePicker(fieldFillColor, fieldLabelColor),
                            const SizedBox(height: 20),
                            _buildTextField(
                              brandController,
                              AppLocalizations.of(context)!.brand,
                              fieldFillColor,
                              fieldTextColor,
                              fieldLabelColor,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              modelController,
                              AppLocalizations.of(context)!.model,
                              fieldFillColor,
                              fieldTextColor,
                              fieldLabelColor,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              yearController,
                              AppLocalizations.of(context)!.year,
                              fieldFillColor,
                              fieldTextColor,
                              fieldLabelColor,
                              isNumber: true,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              plateController,
                              AppLocalizations.of(context)!.platenumber,
                              fieldFillColor,
                              fieldTextColor,
                              fieldLabelColor,
                            ),
                            const SizedBox(height: 12),
                            _buildDropdown(
                              deviceTypes,
                              fieldFillColor,
                              fieldTextColor,
                              fieldLabelColor,
                              isDark,
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Widgets البناء المساعدة لتقليل زحمة الكود ---

  Widget _buildImagePicker(Color? fillColor, Color labelColor) {
    return GestureDetector(
      onTap: pickImage,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          image: selectedImage != null
              ? DecorationImage(
                  image: FileImage(selectedImage!),
                  fit: BoxFit.cover,
                )
              : widget.device?.image != null
              ? DecorationImage(
                  image: NetworkImage(widget.device!.image!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: selectedImage == null && widget.device?.image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: labelColor, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.adddeviceamage,
                    style: TextStyle(color: labelColor),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    Color? fillColor,
    Color textColor,
    Color labelColor, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: fillColor,
          labelStyle: TextStyle(color: labelColor, fontSize: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
      ),
    );
  }

  Widget _buildDropdown(
    List<Map<String, String>> items,
    Color? fillColor,
    Color textColor,
    Color labelColor,
    bool isDark,
  ) {
    return DropdownButtonFormField2<String>(
      value: selectedType,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item['id'],
              child: Text(item['name']!, style: TextStyle(color: textColor)),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => selectedType = value!),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark ? Colors.grey[850] : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<CreateDeviceCubit, CreateDeviceState>(
      builder: (context, createState) {
        return BlocBuilder<UpdateDeviceCubit, UpdateDeviceState>(
          builder: (context, updateState) {
            // التحقق مما إذا كان أي من الـ Cubits في حالة تحميل
            final isLoading =
                createState is CreateDeviceLoading ||
                updateState is UpdateDeviceLoading;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.blue.withOpacity(0.6),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          widget.isEdit ? "Update" : "Create",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // تأكدنا من الـ Validation، الآن نجهز البيانات ونعالج أي قيمة قد تكون Null
      final device = DeviceEntity(
        // 1. تأكد أن الـ ID لا يرسل Null أبداً
        id: widget.device?.id ?? '',

        brand: brandController.text.trim(),
        model: modelController.text.trim(),
        year: int.tryParse(yearController.text) ?? 0,
        plateNumber: plateController.text.trim(),
        type: selectedType,

        // 2. الحماية من Null في الـ UserEntity
        user:
            widget.device?.user ??
            UserEntity(id: '0', name: 'Unknown', email: ''),

        // 3. الخطأ غالباً هنا: الـ Status لا يجب أن يكون Null
        status: widget.device?.status ?? 'active',

        lastRecord: widget.device?.lastRecord,
        image: widget.device?.image,
      );

      if (widget.isEdit) {
        context.read<UpdateDeviceCubit>().updateDevice(
          device,
          image: selectedImage,
        );
      } else {
        context.read<CreateDeviceCubit>().createDevice(
          device,
          image: selectedImage,
        );
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  void dispose() {
    brandController.dispose();
    modelController.dispose();
    yearController.dispose();
    plateController.dispose();
    super.dispose();
  }
}
