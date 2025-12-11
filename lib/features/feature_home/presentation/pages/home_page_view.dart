import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_devices/presentation/views/devices_page.dart';
import 'package:live_tracking/features/feature_google-map/presentation/pages/google_map_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          HomePageBody(),
          DevicesPage(isActive: selectedIndex == 1),
          GoogleMapPage(),
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
