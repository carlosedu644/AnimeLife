import 'package:animelife_firebase/videoPlayer/player-life-cycle/state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef Widget VideoWidgetBuilder(
    BuildContext context, VideoPlayerController controller);

class PlayerLifeCycle extends StatefulWidget {
  final VideoPlayerController controller;
  final VideoWidgetBuilder childBuilder;

  PlayerLifeCycle(this.controller, this.childBuilder, {Key key})
      : super(key: key);

  @override
  PlayerLifeCycleState createState() => PlayerLifeCycleState();
}