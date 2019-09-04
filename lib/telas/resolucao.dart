import 'package:animelife_firebase/telas/index.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mx_player_plugin/mx_player_plugin.dart';

class Resolucao extends StatefulWidget {
  final String link;
  final String title;
  Resolucao({this.link, this.title});

  @override
  _ResolucaoState createState() => _ResolucaoState();
}

class _ResolucaoState extends State<Resolucao> {
  Map data;
  List videoAnime;

  navegationVideo(String slug, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Video(
                  link: slug,
                  title: title,
                )));
  }

  vlcPlayer(String url) async {
    await PlayerPlugin.openWithVlcPlayer(url);
  }

  mxPlayer(String url) async {
    await PlayerPlugin.openWithMxPlayer(url, "");
  }

  Future getVideo() async {
    http.Response response = await http
        .get('http://10.0.2.2:3000/episode/video/${widget.link}');
    data = json.decode(response.body);

    videoAnime = data['video'];

    return videoAnime;
  }

  @override
  void initState() {
    super.initState();
    print(widget.link);

    getVideo().then((videoAnime) {
      setState(() {
        this.videoAnime = videoAnime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoAnime == null) {
      return new Center(child: new CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(height: 40.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () =>
                        navegationVideo(videoAnime[0], "${widget.title}"),
                    color: Colors.lightBlueAccent,
                    child: Text(
                      "Assistir em SD",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () =>
                        navegationVideo(videoAnime[1], "${widget.title}"),
                    color: Colors.lightBlueAccent,
                    child: Text(
                      "Assistir em HD",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () =>
                        navegationVideo(videoAnime[2], "${widget.title}"),
                    color: Colors.lightBlueAccent,
                    child: Text(
                      "Assistir Full HD",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () => mxPlayer(videoAnime[2]),
                    color: Colors.lightBlueAccent,
                    child: Text(
                      "Mx Player",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 200.0,
                    height: 42.0,
                    onPressed: () => vlcPlayer(videoAnime[2]),
                    color: Colors.lightBlueAccent,
                    child: Text(
                      "Vlc Player",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
