import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

final uuid = Uuid();

class PlaceLocation {
  PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  double latitude;
  double longitude;
  final String address;
}

class Photo {
  const Photo({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.location,
  });
  final String name;
  final int id;
  final String imageUrl;
  final PlaceLocation location;
}
