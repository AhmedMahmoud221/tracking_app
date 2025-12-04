import 'package:flutter/material.dart';
import 'package:live_tracking/features/feature_devices/presentation/widgets/devices.dart';
import 'package:live_tracking/features/feature_google-map/presentation/widgets/google_map.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/custom_app_bar.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/custom_bottom_bar.dart';
import 'package:live_tracking/features/feature_home/presentation/pages/home_page_body.dart';
import 'package:live_tracking/features/feature_profile/presentation/widgets/profile.dart';

class HomePageView extends StatefulWidget {
  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    HomePageBody(),
    Devices(),
    LiveGoogleMap(),
    Profile(),
  ];

  final List<String> titles = const [
    "Home Page",
    "Devices",
    "Live Tracking",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(),

      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar: CustomBottomBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
      ),
    );
  }
}
