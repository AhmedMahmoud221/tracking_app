import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/data/device_repo_impl.dart';
import 'package:live_tracking/features/feature_devices/domain/usecases/get_devices_list.dart';
import 'package:live_tracking/features/feature_devices/presentation/bloc/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/bloc/devices_state.dart'
    hide DevicesCubit;
import 'package:live_tracking/features/feature_devices/presentation/widgets/device_card.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DevicesCubit(GetDevicesList(DevicesRepoImpl()))..loadDevices(),
      child: Scaffold(
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
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.error != null) {
                      return Center(child: Text(state.error!));
                    }

                    final devices = state.filteredDevices;

                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        return DeviceCard(device: devices[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
      onChanged: (query) => context.read<DevicesCubit>().searchDevices(query),
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
