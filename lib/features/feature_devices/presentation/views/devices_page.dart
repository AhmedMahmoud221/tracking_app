import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_devices/presentation/widgets/device_card.dart';

class DevicesPage extends StatefulWidget {
  final bool isActive; // <- added for IndexedStack refetch

  const DevicesPage({super.key, required this.isActive});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  void initState() {
    super.initState();
    context.read<DevicesCubit>().fetchDevices(); // first load
  }

  @override
  void didUpdateWidget(covariant DevicesPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // refetch when tab becomes active
    if (!oldWidget.isActive && widget.isActive) {
      context.read<DevicesCubit>().fetchDevices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: _SearchBar(),
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

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        return DeviceCard(device: devices[index]);
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
        fillColor: const Color.fromARGB(255, 240, 238, 238),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
