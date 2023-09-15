import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:map_app/pick_image/widgets/imageNotify.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import './settingScreen.dart';
// import './mapScreen.dart';
import './googleMapScreen.dart';

import '../pick_image/screens/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../stream_camera/liveStreamScreen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var index = 0;
  final bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();
  List<Widget> screenList = [
    const MapSample(),
    const LiveStreamVideo(),
    const ImageNotify(),
    const SettingScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[index],
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
          key: bottomNavigationKey,
          onTap: (index) => setState(() {
                this.index = index;
              }),
          index: index,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Color.fromARGB(172, 0, 0, 0),
          color: Color.fromARGB(172, 0, 0, 0),
          items: const [
            Icon(Icons.map_sharp, color: Colors.white),
            Icon(Icons.live_tv_sharp, color: Colors.white),
            Icon(Icons.photo_library, color: Colors.white),
            Icon(Icons.settings, color: Colors.white),
          ]),
    );
  }
}
