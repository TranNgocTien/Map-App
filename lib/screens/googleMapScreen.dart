
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
// import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'package:map_app/features/location_service.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:map_app/stream_camera/utils/marker_list_data.dart';
import 'package:map_app/stream_camera/utils/currentposition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_app/provider/camera_provider.dart';

class MapSample extends ConsumerStatefulWidget {
  const MapSample({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<MapSample> createState() => MapSampleState();
}

class MapSampleState extends ConsumerState<MapSample> with AutomaticKeepAliveClientMixin{
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();
 @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


   Completer<GoogleMapController> _controller = Completer();
    
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  Uint8List? markerImage;

  List<String> images = [
    'assets/image/location-pin.png',
    'assets/image/security-camera.png'
  ];
 
  late BitmapDescriptor markerbitmap;
  String stAdd = '';
  String stDestination = '';
  // Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  // Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter = 1;
  // int _polylineIdCounter = 1;
  final List<Marker> _marker = <Marker>[];
  final List<Marker> _markerTest = <Marker>[];
  late double latPosition;
  late double longPosition;
  late CurrentLocationClass currentLocationClass;

  LocationData? currentLocation;
  late String error;
  List<Uint8List> iconMarker = [];
  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return locationData = null;
    }
  
    setState(() {
      currentLocation = locationData;
    });

    final Uint8List markerIconCamera = await getBytesFromAssets(images[1], 100);
    final Uint8List markerIconUser = await getBytesFromAssets(images[0], 100);

    iconMarker.addAll([markerIconUser, markerIconCamera]);
    _marker.insert(
      0,
      Marker(
        markerId: const MarkerId('45'),
        position:
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        icon: BitmapDescriptor.fromBytes(iconMarker[0]),
        infoWindow: const InfoWindow(
          title: 'My current location',
        ),
        onTap: null,
      ),
    );
    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            // zoom: 13.5,
            zoom: 15,
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            ),
          ),
        ),
      );
      if(mounted){

      setState(() {});
      }
      onMapCreated(googleMapController);
    });
  }

  // void getCurrentLocation() async {
  //   try {
  //     await location.getLocation().then(
  //       (location) {
  //         setState(() {
  //           currentLocation = location;
  //         });
  //       },
  //     );
  //     error = '';
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       error = 'Permission denied';
  //     } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
  //       error =
  //           'Permission denied - please ask the user to enable it from the app settings';
  //     }

  //     currentLocation = null;
  //   }
  //   // await location.getLocation().then(
  //   //   (location) {
  //   //     setState(() {
  //   //       currentLocation = location;
  //   //     });
  //   //   },
  //   // );
  //   if (currentLocation != null) {
  //     currentLocationClass.currentLocation = currentLocation;
  //     print('===================');
  //     print(currentLocationClass.currentLocation);
  //     print('===================');
  //   } else if (currentLocation == null) {
  //     currentLocation = currentLocationClass.currentLocation;
  //     print('===================');
  //     print(currentLocation);
  //     print('===================');
  //   }
  //   final Uint8List markerIconCamera = await getBytesFromAssets(images[1], 100);
  //   final Uint8List markerIconUser = await getBytesFromAssets(images[0], 100);

  //   iconMarker.addAll([markerIconUser, markerIconCamera]);
  //   _marker.insert(
  //     0,
  //     Marker(
  //       markerId: const MarkerId('45'),
  //       position:
  //           LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
  //       icon: BitmapDescriptor.fromBytes(iconMarker[0]),
  //       infoWindow: const InfoWindow(
  //         title: 'My current location',
  //       ),
  //       onTap: null,
  //     ),
  //   );
  //   GoogleMapController googleMapController = await _controller.future;

  //   location.onLocationChanged.listen((newLoc) {
  //     currentLocation = newLoc;

  //     googleMapController.animateCamera(
  //       CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //           zoom: 13.5,
  //           target: LatLng(
  //             newLoc.latitude!,
  //             newLoc.longitude!,
  //           ),
  //         ),
  //       ),
  //     );

  //     setState(() {});
  //   });
  // }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  void onMapCreated(GoogleMapController controller) {
    if(!_controller.isCompleted){
      _controller.complete(controller);
    }
  }
  @override
  void dispose() {
 
   _controller=Completer();
    super.dispose();
  }

  @override
  void initState() {
    _getCurrentLocation();

    super.initState();
  }

  loadData(List<MarkerList> addCamera) async {
    // final addCamera = ref.watch(addCameraMarkerProvider);
    final Uint8List markerIconCamera = await getBytesFromAssets(images[1], 100);
    if (!mounted) return;
    for (var i = 0; i < markers.length; i++) {
      final isCameraAdded = addCamera.contains(markers[i]);
      var nameButton = 'Camera';
      _markerTest.add(
        Marker(
            markerId: MarkerId(markers[i].id),
            position: LatLng(
              markers[i].latitude,
              markers[i].longitude,
            ),
            icon: BitmapDescriptor.fromBytes(markerIconCamera),
            infoWindow: InfoWindow(
              title: markers[i].title,
            ),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final wasAdded = ref
                            .read(addCameraMarkerProvider.notifier)
                            .addMarkerToList(markers[i]);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        if (mounted) {
                        setState(() {
                          nameButton =
                              isCameraAdded ? 'Remove Camera' : ' Camera';
                        });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                wasAdded ? 'Camera added.' : 'Camera removed.'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        nameButton,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // List<Placemark> placemarksDestination =
                        //     await placemarkFromCoordinates(
                        //         markers[i].latitude, markers[i].longitude);
                        // stDestination = placemarksDestination
                        //         .reversed.last.country
                        //         .toString() +
                        //     "," +
                        //     placemarksDestination.reversed.last.locality
                        //         .toString() +
                        //     "," +
                        //     placemarksDestination.reversed.last.street
                        //         .toString();
                        // List<Placemark> placemarks =
                        //     await placemarkFromCoordinates(
                        //         latPosition, longPosition);
                        // stAdd = placemarks.reversed.last.country.toString() +
                        //     ',' +
                        //     placemarks.reversed.last.locality.toString() +
                        //     ',' +
                        //     placemarks.reversed.last.street.toString();
                        // var place =
                        //     await LocationService().getPlace(_searchController.text);
                        // _goToPlace(place);
                        // var directions = await LocationService()
                        //     .getDirections(stAdd, stDestination);
                        // _goToPlace(
                        //   directions['start_location']['lat'],
                        //   directions['start_location']['lng'],
                        //   directions['bounds_ne'],
                        //   directions['bounds_sw'],
                        // );
                        // _setPolyline(directions['polyline_decoded']);
                        getPolyPoints(
                            markers[i].latitude, markers[i].longitude);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Get direction',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // ),
                LatLng(
                  markers[i].latitude,
                  markers[i].longitude,
                ),
              );
            }),
      );
      if (mounted) {
      setState(() {});
      }
    }
    if (mounted) {
    setState(() {
      _marker.addAll(_markerTest);
    });
    }
  }
//   loadData() {
//     for (var i = 0; i < _list.length; i++) {
//       // Uint8List? image= await loadNetWorkImage('')
//       _marker.add(
//         Marker(
//             markerId: _list[i].markerId,
//             position: _list[i].position,
//             icon: BitmapDescriptor.fromBytes(
//                 'assets/image/pngwing.com.png' as Uint8List),
//             infoWindow: InfoWindow(
//                 snippet: _list[i].infoWindow.title.toString() + i.toString())),
//       );
//       setState(() {});
//     }
//   }

  List<LatLng> polylineCoordinate = [];

  void getPolyPoints(double destinationLat, double destinationLong) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      LocationService().key,
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      PointLatLng(destinationLat, destinationLong),
    );
    polylineCoordinate = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        print(point);

        return polylineCoordinate.add(
          LatLng(point.latitude, point.longitude),
        );
      });
      if (mounted) {
      setState(() {});
      }
    }
  }

  void _setMarker(LatLng point) {
    if (mounted) {
    setState(() {
      _marker.add(
        Marker(markerId: const MarkerId('marker'), position: point),
      );
    });
    }
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  // void _setPolyline(List<PointLatLng> points) {
  //   final String polylineIdVal = 'polyline_$_polylineIdCounter';
  //   _polylineIdCounter++;

  //   _polylines.add(
  //     Polyline(
  //       polylineId: PolylineId(polylineIdVal),
  //       width: 2,
  //       color: Colors.blue,
  //       points: points
  //           .map(
  //             (point) => LatLng(point.latitude, point.longitude),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }

  // Future<Position> getUserCurrentLocation() async {
  //   await Geolocator.requestPermission()
  //       .then((value) {})
  //       .onError((error, stackTrace) {
  //     print(
  //       "error" + error.toString(),
  //     );
  //   });

  //   return await Geolocator.getCurrentPosition();
  // }

  // void getLatLongCurrentPosition() {
  //   getUserCurrentLocation().then((value) {
  //     print(value.latitude.toString() + '' + value.longitude.toString());
  //     setState(() {
  //       latPosition = value.latitude;
  //       longPosition = value.longitude;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final addCamera = ref.watch(addCameraMarkerProvider);
    loadData(addCamera);
    return Scaffold(
      body: currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Row(
                //   children: [
                //     // Expanded(
                //     //   child: Column(
                //     //     children: [
                //     //       TextFormField(
                //     //         controller: _originController,
                //     //         decoration: const InputDecoration(hintText: 'Origin'),
                //     //         onChanged: (value) {
                //     //           print(value);
                //     //         },
                //     //       ),
                //     //       TextFormField(
                //     //         controller: _destinationController,
                //     //         decoration:
                //     //             const InputDecoration(hintText: 'Destination'),
                //     //         onChanged: (value) {
                //     //           print(value);
                //     //         },
                //     //       ),
                //     //     ],
                //     //   ),
                //     // ),
                //     IconButton(
                //       onPressed: () async {
                //         // var place =
                //         //     await LocationService().getPlace(_searchController.text);
                //         // _goToPlace(place);
                //         var directions = await LocationService().getDirections(
                //             _originController.text, _destinationController.text);
                //         _goToPlace(
                //           directions['start_location']['lat'],
                //           directions['start_location']['lng'],
                //           directions['bounds_ne'],
                //           directions['bounds_sw'],
                //         );
                //         _setPolyline(directions['polyline_decoded']);
                //       },
                //       icon: const Icon(Icons.search),
                //     )
                //   ],
                // ),
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         controller: _searchController,

                //         decoration: const InputDecoration(
                //           prefixIcon: Icon(Icons.location_on_outlined),
                //           hintText: 'Search for Location',
                //           contentPadding: EdgeInsets.all(16.0),
                //         ),
                //         onChanged: (value) {
                //           print(value);
                //         },
                //       ),
                //     ),
                //     IconButton(
                //       onPressed: () async {
                //         var place =
                //             await LocationService().getPlace(_searchController.text);
                //         _goToPlace(place);
                //       },
                //       icon: const Icon(Icons.search),
                //     ),
                //   ],
                // ),
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.hybrid,
                        markers: Set<Marker>.of(_marker),
                        zoomGesturesEnabled: true,
                        minMaxZoomPreference:const  MinMaxZoomPreference(15,21),
                        polygons: _polygons,

                        polylines: {
                          Polyline(
                            polylineId: PolylineId("route"),
                            points: polylineCoordinate,
                            color: Colors.blueAccent,
                            width: 6,
                          ),
                        },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            zoom: 15),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          _customInfoWindowController.googleMapController =
                              controller;
                              onMapCreated(controller);
                        },
                        
                        // onTap: (position) {
                        //   _customInfoWindowController.hideInfoWindow!();

                        //   // setState(
                        //   //   () {
                        //   //     polygonLatLngs.add(point);
                        //   //     _setPolygon();
                        //   //   },
                        //   // );
                        // },
                        // onCameraMove: (position) {
                        //   _customInfoWindowController.onCameraMove!();
                        // },
                      ),
                      CustomInfoWindow(
                        controller: _customInfoWindowController,
                        height: 150,
                        width: 100,
                        offset: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: const Text('To the lake!'),
      //   icon: const Icon(Icons.directions_boat),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   focusColor: Colors.black,
      //   onPressed: () async {
      //     // print('Get Location');
      //     // _getCurrentLocation();

      //     loadData(addCamera);
      //     Location location = Location();
      //     location.getLocation().then(
      //       (location) async {
      //         if (mounted) {
      //         setState(() {
      //           currentLocation = location;
      //         });
      //         }

      //         _marker.insert(
      //           0,
      //           Marker(
      //             markerId: const MarkerId('45'),
      //             position: LatLng(
      //                 currentLocation!.latitude!, currentLocation!.longitude!),
      //             icon: BitmapDescriptor.fromBytes(iconMarker[0]),
      //             infoWindow: const InfoWindow(
      //               title: 'My current location',
      //             ),
      //             onTap: null,
      //           ),
      //         );
      //         if (mounted) {
      //         setState(() {});
      //         }
      //         print(_marker);
      //         CameraPosition cameraPosition = CameraPosition(
      //           // zoom: 13.5,
      //            zoom: 14.5,
      //           target: LatLng(
      //               currentLocation!.latitude!, currentLocation!.longitude!),
      //         );
      //         final GoogleMapController controller = await _controller.future;

      //         controller.animateCamera(
      //           CameraUpdate.newCameraPosition(cameraPosition),
      //         );
      //         if (mounted) {
      //         setState(() {});
      //         }
      //       },
      //     );
      //     // getUserCurrentLocation().then((value) async {
      //     //   // print(value.latitude.toString() + ' ' + value.longitude.toString());

      //     //   // latPosition = value.latitude;
      //     //   // longPosition = value.longitude;

      //     // });
      //   },
      //   child: const Icon(Icons.location_searching_outlined),
      // ),
    );
  }

  // Future<void> _goToPlace(
  //   // Map<String, dynamic> place,
  //   double lat,
  //   double lng,
  //   Map<String, dynamic> boundsNe,
  //   Map<String, dynamic> boundsSw,
  // ) async {
  //   // final double lat = place['geometry']['location']['lat'];
  //   // final double lng = place['geometry']['location']['lng'];

  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(lat, lng), zoom: 12),
  //     ),
  //   );

  //   controller.animateCamera(
  //     CameraUpdate.newLatLngBounds(
  //         LatLngBounds(
  //           southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
  //           northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
  //         ),
  //         25),
  //   );
  //   _setMarker(LatLng(lat, lng));
  // }
}
