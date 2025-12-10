import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/presentation/bloc/devices_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/cubit/devices_map_cubit.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        await context.push('/create-device');

        context.read<DevicesCubit>().getDevicesList();
        context.read<DevicesMapCubit>().getDevicesList();
      },
    );
  }
}
