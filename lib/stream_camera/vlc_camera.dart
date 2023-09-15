import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import './fullStreamVideo.dart';

class StreamBuilderCamera extends StatefulWidget {
  const StreamBuilderCamera({
    Key? key,
    required this.url,
    required this.adrress,
  }) : super(key: key);
  final String url;
  final String adrress;
  @override
  _StreamBuilderCameraState createState() => _StreamBuilderCameraState();
}

class _StreamBuilderCameraState extends State<StreamBuilderCamera> {
  bool _isPlaying = true;

  late VlcPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {
    _videoPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    VlcMediaEventType.buffering;
  }

  void main() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
    _videoPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    VlcMediaEventType.buffering;
  }

  @override
  void dispose() async {
    super.dispose();
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: VlcPlayer(
              controller: _videoPlayerController,
              aspectRatio: 16 / 9,
              // aspectRatio: _videoPlayerController.value.aspectRatio,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.adrress,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )),
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
                            size: 16,
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
                              _videoPlayerController.pause();
                            } else {
                              setState(() {
                                _isPlaying = true;
                              });
                              _videoPlayerController.play();
                            }
                          },
                          child: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: const Icon(
                            Icons.fast_forward,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return VideoScreen(
                                url: widget.url,
                              );
                            }));
                          },
                          child: const Icon(
                            Icons.fullscreen,
                            size: 16,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
