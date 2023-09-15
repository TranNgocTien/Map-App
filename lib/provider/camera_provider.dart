import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_app/stream_camera/utils/marker_list.dart';

class AddCameraMarkerNotifier extends StateNotifier<List<MarkerList>> {
  AddCameraMarkerNotifier() : super([]);

  bool addMarkerToList(MarkerList marker) {
    final markerAdded = state.contains(marker);

    if (markerAdded) {
      state = state.where((m) => m.id != marker.id).toList();
      return false;
    } else {
      state = [...state, marker];
      return true;
    }
  }
}

final addCameraMarkerProvider =
    StateNotifierProvider<AddCameraMarkerNotifier, List<MarkerList>>((ref) {
  return AddCameraMarkerNotifier();
});
