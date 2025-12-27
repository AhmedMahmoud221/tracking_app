import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_devices/presentation/widgets/device_card.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/delete_device_cubit/delete_device_cubit.dart';
import 'package:live_tracking/features/feature_home/presentation/cubits/delete_device_cubit/delete_device_state.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class DevicesPage extends StatefulWidget {
  final bool isActive;

  const DevicesPage({super.key, required this.isActive});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  void initState() {
    super.initState();
    context.read<DevicesCubit>().fetchDevices();
  }

  @override
  void didUpdateWidget(covariant DevicesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      context.read<DevicesCubit>().fetchDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocListener(
      listeners: [
        // الاستماع لعملية الحذف لتحديث القائمة فوراً
        BlocListener<DeleteDeviceCubit, DeleteDeviceState>(
          listener: (context, state) {
            if (state is DeleteDeviceSuccess) {
              context.read<DevicesCubit>().deleteDeviceFromList(state.deviceId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.deviceupdatedsuccessfully,
                  ),
                ), // يمكنك تغيير الترجمة لـ Deleted
              );
            }
            if (state is DeleteDeviceError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<DevicesCubit, DevicesState>(
        builder: (context, state) {
          // حساب عدد الأجهزة المتاحة حالياً في الـ UI
          int count = 0;
          if (state is DevicesLoaded) {
            count = state.devices.length;
          }

          return Scaffold(
            backgroundColor: isDark ? Colors.black : Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // السيرش بار موجود هنا
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: _SearchBar(isDark: isDark),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${AppLocalizations.of(context)!.alldevices} : $count',
                            style: TextStyle(
                              fontSize: 20,
                              color: isDark ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await context.push(
                              '/add_edit-device',
                            );
                            if (result == true) {
                              context.read<DevicesCubit>().fetchDevices();
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            AppLocalizations.of(context)!.adddevice,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue,
                            elevation: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // محتوى الشبكة (Grid)
                  Expanded(child: _buildBody(state, isDark)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة بناء المحتوى لفصل المنطق عن التصميم
  Widget _buildBody(DevicesState state, bool isDark) {
    if (state is DevicesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is DevicesLoaded) {
      if (state.devices.isEmpty) {
        return Center(
          child: Text(
            AppLocalizations.of(context)!.nodevicesfound,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: state.devices.length,
        itemBuilder: (context, index) {
          return DeviceCardGrid(device: state.devices[index]);
        },
      );
    }
    if (state is DevicesError) {
      return Center(
        child: Text(
          "Error: ${state.message}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return const SizedBox();
  }
}

// السيرش بار كـ Widget منفصل كما أرسلته أنت
class _SearchBar extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final bool isDark;

  _SearchBar({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (query) {
        context.read<DevicesCubit>().searchDevices(query);
      },
      decoration: InputDecoration(
        hintText: "${AppLocalizations.of(context)!.searchdevices}...",
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        prefixIcon: Icon(
          Icons.search,
          color: isDark ? Colors.white : Colors.grey,
        ),
        filled: true,
        fillColor: isDark
            ? Colors.grey[850]
            : const Color.fromARGB(255, 243, 242, 242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
    );
  }
}
