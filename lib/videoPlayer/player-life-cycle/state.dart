import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';
import 'index.dart';

class PlayerLifeCycleState extends State<PlayerLifeCycle> {
  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.value.hasError) {
        Center(child:Text("Erro ao Carregar Episodio", style: TextStyle(color: Colors.red, fontSize: 25),));
      }
    });
    controller.initialize();
    controller.setLooping(false);
    controller.play();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return widget.childBuilder(context, controller);
  }
}