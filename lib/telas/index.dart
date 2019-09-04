import 'package:animelife_firebase/telas/state.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {
  final String title;
  final String link;
  final String image;
  
  Video({Key key, this.title, this.link, this.image}) : super(key: key);

  @override
  VideoState createState() => VideoState();
  
}