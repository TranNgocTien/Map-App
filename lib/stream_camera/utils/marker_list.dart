import 'package:uuid/uuid.dart';
import 'dart:io';

final uuid = Uuid();

class MarkerList {
  MarkerList(
      {required this.title,
      required this.longitude,
      required this.latitude,
      required this.address,
      required this.linkCamera,
      String? id})
      : id = id ?? uuid.v4();
  final String title;
  final double latitude;
  final double longitude;
  final String id;
  final String address;
  final String linkCamera;
}


// import 'package:uuid/uuid.dart';
// import 'dart:io';

// final uuid = Uuid();

// class PlaceLocation {
//   const PlaceLocation(
//       {required this.latitude, required this.longitude, required this.address});
//   final double latitude;
//   final double longitude;
//   final String address;
// }

// class Place {
//   Place(
//       {required this.title,
//       required this.image,
//       required this.location,
//       String? id})
//       : id = id ?? uuid.v4();

//   final String id;
//   final String title;
//   final File image;
//   final PlaceLocation location;
// }
