import 'dart:async';
import 'package:animelife_firebase/videoPlayer/player-controls/index.dart';
import 'package:animelife_firebase/videoPlayer/player-life-cycle/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'index.dart';


class VideoState extends State<Video> {
  VideoPlayerController vcontroller;
  bool controlVisible;
  Timer timer;

  @override
  void initState() {
    controlVisible = true;
    super.initState();

    autoHide();

    vcontroller = VideoPlayerController.network(widget.link);

    print(widget.link);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    vcontroller?.dispose();
    timer?.cancel();

    

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  void handlerGesture() {
    setState(() {
      controlVisible = !controlVisible;
    });
    autoHide();
  }

  void autoHide() {
    if (controlVisible) {
      timer = Timer(
          Duration(seconds: 5), () => setState(() => controlVisible = false));
    } else {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = 0.75;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          PlayerLifeCycle(
            vcontroller,
            (BuildContext context, VideoPlayerController controller) =>
                AspectRatio(
                  aspectRatio: aspectRatio,
                  child: VideoPlayer(vcontroller),
                ),
          ),
          GestureDetector(
            child: PlayerControl(
              vcontroller,
              visible: controlVisible,
              title: widget.title,
            ),
            onTap: handlerGesture,
          ),
        ],
      ),
    );
  }
}
