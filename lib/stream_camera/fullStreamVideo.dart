import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with TickerProviderStateMixin {
  bool _isPlaying = true;
  late VlcPlayerController vlcController;

  late AnimationController _scaleVideoAnimationController;
  Animation<double> _scaleVideoAnimation =
      const AlwaysStoppedAnimation<double>(1.0);
  double? _targetVideoScale;

  double _lastZoomGestureScale = 1.0;
  bool isRecording = false;
  @override
  void initState() {
    super.initState();
    isRecording = false;
    _forceLandscape();
    VlcMediaEventType.buffering;
    _scaleVideoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 125),
      vsync: this,
    );

    var videoURL = widget.url;
    vlcController = VlcPlayerController.network(
      videoURL,
      autoPlay: true,
      hwAcc: HwAcc.full,
    );

    // Uncomment  if you want autoplay to stop
    // vlcController.addOnInitListener(_stopAutoplay);
  }

  void setTargetNativeScale(double newValue) {
    if (!newValue.isFinite) {
      return;
    }
    _scaleVideoAnimation =
        Tween<double>(begin: 1.0, end: newValue).animate(CurvedAnimation(
      parent: _scaleVideoAnimationController,
      curve: Curves.easeInOut,
    ));

    if (_targetVideoScale == null) {
      _scaleVideoAnimationController.forward();
    }
    _targetVideoScale = newValue;
  }

  Future<void> _stopAutoplay() async {
    await vlcController.pause();
    await vlcController.play();

    await vlcController.setVolume(0);

    await Future.delayed(const Duration(milliseconds: 150), () async {
      await vlcController.pause();
      await vlcController.setTime(0);
      await vlcController.setVolume(100);
    });
  }

  Future<void> _forceLandscape() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _forcePortrait() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

//   Future<bool?> startRecording(String saveDirectory) async {
//     print('startRecording');
//     return await vlcController.startRecording(widget.title, saveDirectory);
//   }
//   Future<bool?> stopRecording() async {
//   print('stopRecording');
//   return await vlcController.stopRecording();
// }
  @override
  void dispose() {
    _forcePortrait();

    vlcController.removeOnInitListener(_stopAutoplay);
    vlcController.stopRendererScanning();
    vlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final videoSize = vlcController.value.size;
    if (videoSize.width > 0) {
      final newTargetScale = screenSize.width /
          (videoSize.width * screenSize.height / videoSize.height);
      setTargetNativeScale(newTargetScale);
    }

    final vlcPlayer = VlcPlayer(
        controller: vlcController,
        aspectRatio: screenSize.width / screenSize.height,
        placeholder: const Center(child: CircularProgressIndicator()));

    return Scaffold(
        body: Material(
      color: Colors.transparent,
      child: GestureDetector(
        onScaleUpdate: (details) {
          _lastZoomGestureScale = details.scale;
        },
        onScaleEnd: (details) {
          if (_lastZoomGestureScale > 1.0) {
            setState(() {
              // Zoom in
              _scaleVideoAnimationController.forward();
            });
          } else if (_lastZoomGestureScale < 1.0) {
            setState(() {
              // Zoom out
              _scaleVideoAnimationController.reverse();
            });
          }
          _lastZoomGestureScale = 1.0;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                // Background behind the video
                color: Colors.black,
              ),
            ),
            Center(
                child: ScaleTransition(
                    scale: _scaleVideoAnimation,
                    child: AspectRatio(aspectRatio: 16 / 9, child: vlcPlayer))),
            Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.fast_rewind,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              if (_isPlaying) {
                                setState(() {
                                  _isPlaying = false;
                                });
                                vlcController.pause();
                              } else {
                                setState(() {
                                  _isPlaying = true;
                                });
                                vlcController.play();
                              }
                            },
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: () {},
                            child: const Icon(
                              Icons.fast_forward,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              if (isRecording == false) {
                                setState(() {
                                  vlcController.startRecording;
                                  isRecording = true;
                                });
                              } else if (isRecording == true) {
                                setState(() {
                                  vlcController.stopRecording();
                                  isRecording = false;
                                });
                              }
                            },
                            child: Icon(
                              isRecording
                                  ? Icons.emergency_recording
                                  : Icons.stop_circle_outlined,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
