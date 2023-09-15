import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../screens/map.dart';
import 'package:flutter/material.dart';
import '../models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  String get locationImage {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=AIzaSyDbccsuPPZP8ATGJIAosGzRza2btoyRfXI';
  }

  @override
  Widget build(BuildContext context) {
    void sendImage() async {
      Uint8List imagebytes = await place.image.readAsBytes();
      String base64String = base64Encode(imagebytes);
      int sizeImage = base64String.length;

      Socket s = await Socket.connect('119.17.253.45', 8878);
      s.write(sizeImage);
      print(sizeImage);
      String stringBase64 = base64String;
      String imageStringSub = '';
      var i = 0;
      while (stringBase64.isNotEmpty) {
        if (stringBase64.length > 10241) {
          imageStringSub = stringBase64.substring(0, 10241);
          print('*******************SUBSTRING lan $i');
          s.write(imageStringSub);
          print(imageStringSub);
          i += 1;
          stringBase64 = stringBase64.substring(10241);
          print(stringBase64.length);
        } else if (stringBase64.length <= 10241) {
          print('*******************SUBSTRING lan $i');
          print('*******************SUBSTRING lan cuoi');
          imageStringSub = stringBase64;
          print(imageStringSub);
          stringBase64 = '';
          s.write(imageStringSub);
        }
      }

      print('ok: data written');
      s.close();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
        actions: [
          IconButton(onPressed: sendImage, icon: const Icon(Icons.send))
        ],
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MapScreen(
                          location: place.location,
                          isSelecting: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
