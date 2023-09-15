import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './utils/mock_data.dart';
import 'vlc_camera.dart';
import 'package:map_app/stream_camera/utils/marker_list_data.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_app/provider/camera_provider.dart';

class Camera extends ConsumerStatefulWidget {
  const Camera({
    super.key,
  });
  // final List<MarkerList> listMarker;
  @override
  ConsumerState<Camera> createState() => _CameraState();
}

class _CameraState extends ConsumerState<Camera> {
  @override
  Widget build(BuildContext context) {
    final cameraList = ref.watch(addCameraMarkerProvider);
    List<MarkerList> cameraMap = cameraList;
    return CarouselSlider(
        items: cameraMap.map(
          (camera) {
            return Builder(
              builder: (BuildContext ctx) {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    color: Colors.black,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: StreamBuilderCamera(
                        url: camera.linkCamera,
                        adrress: camera.address,
                      ),
                    ));
              },
            );
          },
        ).toList(),
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.4,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ));
  }
}
