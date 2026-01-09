import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_tracking/core/errors/show_snack_bar.dart';
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

            if (allDevices.isEmpty) {
              return const Center(child: Text("لا توجد أجهزة مضافة حالياً"));
            }

            final total = allDevices.length;

            final idling = allDevices
                .where((d) => d.status.toLowerCase() == 'idling')
                .length;
            final moving = allDevices
                .where((d) => d.status.toLowerCase() == 'moving')
                .length;
            final parking = allDevices
                .where((d) => d.status.toLowerCase() == 'parking')
                .length;

            final lastDevice = allDevices.isNotEmpty ? allDevices.last : null;

            return RefreshIndicator(
              color: Colors.blue,
              onRefresh: () async =>
                  context.read<DevicesCubit>().fetchDevices(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            title: AppLocalizations.of(context)!.idling,
                            value: '$idling',
                            icon: Icons.pause_circle_filled,
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
                        onTrack: widget.onTrackLastDevice,
                      ),
                      // const SizedBox(height: 16),
                      // QuickActionsCard(),
                      const SizedBox(height: 20),

                      RecentActivitiesCard(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is DevicesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      // هنا بنستخدم الـ Handler اللي أنت بعته عشان نترجم الخطأ
                      ApiErrorHandler.handle(state.message),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<DevicesCubit>()
                          .fetchDevices(), // استدعاء الداتا تاني
                      icon: const Icon(Icons.refresh),
                      label: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
