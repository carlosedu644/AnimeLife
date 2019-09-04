import 'package:animelife_firebase/videoPlayer/player-controls/state.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerControl extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;
  final bool visible;

  PlayerControl(this.controller, {this.visible, this.title, Key key}) : super(key: key);

  @override
  PlayerControlState createState() => PlayerControlState();
}