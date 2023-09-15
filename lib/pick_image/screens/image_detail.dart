import 'package:flutter/material.dart';
import 'package:map_app/pick_image/models/imageData.dart';

import 'package:map_app/pick_image/screens/map_image_location.dart';

class ImageDetailScreen extends StatelessWidget {
  const ImageDetailScreen({
    super.key,
    required this.imageDetailLocation,
    required this.imageData,
  });

  final ImageDetailLocation imageDetailLocation;
  final ImageData imageData;
  String get locationImage {
    final lat = imageDetailLocation.latitude;
    final lng = imageDetailLocation.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=AIzaSyDbccsuPPZP8ATGJIAosGzRza2btoyRfXI';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageData.nameOfPersonImage),
      ),
      body: Stack(
        children: [
          Image.network(
            imageData.imageUrl,
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
                        builder: (ctx) => ImageMapScreen(
                          isSelecting: false,
                          location: imageDetailLocation,
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
                    imageData.address,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
