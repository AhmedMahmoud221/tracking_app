import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_state.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/last_tracked_card.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/recent_activites_card.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/state_card.dart';
import 'package:live_tracking/l10n/app_localizations.dart';

class HomePageBody extends StatefulWidget {
  final void Function(DeviceEntity device) onTrackLastDevice;
  
  const HomePageBody({super.key, required this.onTrackLastDevice});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.black
        : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocBuilder<DevicesCubit, DevicesState>(
        builder: (context, state) {
          if (state is DevicesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DevicesLoaded) {
            final allDevices = state.devices;

            final total = allDevices.length;

            // final online = allDevices
            //     .where((d) => d.status.toLowerCase() == 'online')
            //     .length;
            final towed = allDevices
                .where((d) => d.status.toLowerCase() == 'towed')
                .length;
            final moving = allDevices
                .where((d) => d.status.toLowerCase() == 'moving')
                .length;
            final parking = allDevices
                .where((d) => d.status.toLowerCase() == 'parking')
                .length;

            final lastDevice = allDevices.isNotEmpty ? allDevices.last : null;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 2.3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        StatCard(
                          title: AppLocalizations.of(context)!.totaldevices,
                          value: '$total',
                          icon: Icons.devices,
                        ),
                        StatCard(
                          title: AppLocalizations.of(context)!.towed,
                          value: '$towed',
                          icon: Icons.car_crash,
                        ),
                        StatCard(
                          title: AppLocalizations.of(context)!.parking,
                          value: '$parking',
                          icon: Icons.directions_car,
                        ),
                        StatCard(
                          title: AppLocalizations.of(context)!.moving,
                          value: '$moving',
                          icon: Icons.speed,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    LastTrackedCard(
                      device: lastDevice,
                      onTrack: widget.onTrackLastDevice
                    ),
                    // const SizedBox(height: 16),
                    // QuickActionsCard(),
                    const SizedBox(height: 20),

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
      ),
    );
  }
}
