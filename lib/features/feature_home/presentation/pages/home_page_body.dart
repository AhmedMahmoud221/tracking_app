import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:live_tracking/features/feature_devices/presentation/cubit/devices_cubit.dart';
import 'package:live_tracking/features/feature_google-map/presentation/cubit/devices_map_cubit.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Buttom'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await context.push('/create-device');

              // نفحص إذا كانت القيمة المرجعة (result) هي true
              if (result == true) {
                // الآن فقط نستدعي تحديث البيانات لأن الإضافة نجحت
                context.read<DevicesCubit>().fetchDevices();
                context.read<DevicesMapCubit>().loadDevices();
              }
            },
          ),
        ],
      ),
    );
  }
}
