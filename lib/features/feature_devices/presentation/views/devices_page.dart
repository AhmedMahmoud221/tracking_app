import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_devices/presentation/widgets/device_card.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _SearchBar(),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await context.push('/create-device');
                    if (result == true) {
                      context.read<DevicesCubit>().fetchDevices();
                    }
                  },
                  icon: const Icon(Icons.add, size: 24, color: Colors.white),
                  label: const Text(
                    'Create Device',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<DevicesCubit, DevicesState>(
                builder: (context, state) {
                  if (state is DevicesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DevicesLoaded) {
                    final devices = state.devices;
                    if (devices.isEmpty) {
                      return const Center(child: Text("No Devices Found"));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // جهازين في الصف
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        return DeviceCardGrid(device: devices[index]);
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _SearchBar extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (query) {
        context.read<DevicesCubit>().searchDevices(query);
      },
      decoration: InputDecoration(
        hintText: "Search devices...",
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: const Color.fromARGB(255, 243, 242, 242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}