import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_chat/presentation/widgets/chat_page_body.dart';
import 'package:live_tracking/features/feature_devices/domain/entities/device_entity.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/devices_page.dart';
import 'package:live_tracking/features/feature_google_map/presentation/pages/google_map_page.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/custom_app_bar.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/custom_bottom_bar.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/home_page_body.dart';
import 'package:live_tracking/features/feature_profile/presentation/widgets/profile.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int selectedIndex = 0;
  DeviceEntity? selectedDevice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePageBody(
            onTrackLastDevice: (device) {
              setState(() {
                selectedDevice = device;
                selectedIndex = 2;
              });
            },
          ),
          DevicesPage(isActive: selectedIndex == 1),
          GoogleMapPage(),
          ChatPageBody(),
          Profile(),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
