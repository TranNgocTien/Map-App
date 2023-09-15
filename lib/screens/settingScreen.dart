import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:map_app/setting_widget/settings_tile.dart';
import './editProfile.dart';
import 'package:map_app/screens/addMarkerScreens/list_marker-screens.dart';
import 'package:map_app/pick_image/screens/places.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            SettingsTile(
              color: Colors.blue,
              icon: Ionicons.person_circle_outline,
              title: "Account",
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfileUI()));
              },
            ),
            const SizedBox(height: 10),
            SettingsTile(
              color: Colors.black,
              icon: Ionicons.location_outline,
              title: "Add Location",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ListMarkerScreen(),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SettingsTile(
              color: Colors.greenAccent,
              icon: Ionicons.camera,
              title: 'Scan camera',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PlacesScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            SettingsTile(
              color: Colors.red,
              icon: Ionicons.log_out_outline,
              title: "Log out",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
