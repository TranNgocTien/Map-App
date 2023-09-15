import 'package:flutter/material.dart';

import 'package:map_app/pick_image/models/imageData.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ImageMapScreen extends StatefulWidget {
  const ImageMapScreen({
    super.key,
    this.location = const ImageDetailLocation(
        latitude: 37.422, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });

  final ImageDetailLocation location;
  final bool isSelecting;
  @override
  State<ImageMapScreen> createState() => _ImageMapScreenState();
}

class _ImageMapScreenState extends State<ImageMapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
          onTap: !widget.isSelecting
              ? null
              : (position) {
                  setState(() {
                    _pickedLocation = position;
                  });
                },
          initialCameraPosition: CameraPosition(
            target: LatLng(
              widget.location.latitude,
              widget.location.longitude,
            ),
            zoom: 16,
          ),
          markers: (_pickedLocation == null && widget.isSelecting)
              ? {}
              : {
                  Marker(
                    markerId: const MarkerId('m1'),
                    position: _pickedLocation ??
                        LatLng(
                          widget.location.latitude,
                          widget.location.longitude,
                        ),
                  )
                }),
    );
  }
}
