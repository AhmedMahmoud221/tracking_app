import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/last_tracked_card.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/quick_actions_card.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/recent_activites_card.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/state_card.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        if (state is DevicesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DevicesLoaded) {
          final allDevices = state.devices;

          final total = allDevices.length;
          final online = allDevices
              .where((d) => d.status.toLowerCase() == 'online')
              .length;
          final offline = allDevices
              .where((d) => d.status.toLowerCase() != 'online')
              .length;
          final moving = allDevices
              .where((d) => d.status.toLowerCase() == 'moving')
              .length;

          final lastDevice = allDevices.isNotEmpty ? allDevices.last : null;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Stats Grid
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      StatCard(
                        title: 'Total Devices',
                        value: '$total',
                        icon: Icons.directions_car,
                      ),
                      StatCard(
                        title: 'Online',
                        value: '$online',
                        icon: Icons.wifi,
                      ),
                      StatCard(
                        title: 'Offline',
                        value: '$offline',
                        icon: Icons.wifi_off,
                      ),
                      StatCard(
                        title: 'Moving',
                        value: '$moving',
                        icon: Icons.speed,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Last Tracked Device + Quick Actions
                  LastTrackedCard(device: lastDevice),
                  const SizedBox(height: 16),
                  QuickActionsCard(),

                  const SizedBox(height: 20),

                  // Recent Activities
                  RecentActivitiesCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        } else if (state is DevicesError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
