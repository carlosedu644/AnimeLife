import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animelife_firebase/telas/index.dart';
import 'package:mx_player_plugin/mx_player_plugin.dart';
import 'package:device_apps/device_apps.dart';
import 'package:device_id/device_id.dart';

final TextStyle topMenuStyle =
    TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold);

List videoAnime = new List();
Map data;

bool vlcIsInstalled;
bool mxPlayerIsInstalled;
String deviceId;

Widget makeContinueWatching(
    String title, List listRecentes, BuildContext context) {
  return Container(
    padding: EdgeInsets.only(left: 5, right: 5),
    height: 240,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[Text(title, style: topMenuStyle)],
          ),
        ),
        Container(
          height: 200,
          child: ListView(
            padding: EdgeInsets.all(3),
            scrollDirection: Axis.horizontal,
            children: makeContinueContainers(listRecentes, context),
          ),
        )
      ],
    ),
  );
}
 Future getDeviceId() async{
 return await DeviceId.getID;
  }

int counter = 0;
List<Widget> makeContinueContainers(List listRecentes, BuildContext context) {
  getDeviceId().then((id){
    deviceId = id;
  });
  
  verifyinstalledApps() async {
    vlcIsInstalled = await DeviceApps.isAppInstalled('org.videolan.vlc') == null
        ? false
        : vlcIsInstalled = await DeviceApps.isAppInstalled('org.videolan.vlc');
    mxPlayerIsInstalled =
        await DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad') == null
            ? false
            : mxPlayerIsInstalled =
                await DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad');
  }

  verifyinstalledApps();
  List<Container> movieList = [];

  for (var i = 0; i < listRecentes.length; i++) {
    double mid = "${listRecentes[i]['title']}".trim().length / 2;
    counter++;
    movieList.add(Container(
      padding: EdgeInsets.all(5),
      height: 200,
      width: 120,
      child: Column(
        children: <Widget>[
          Container(
            height: 140,
            width: 155,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new CachedNetworkImageProvider(
                  '${listRecentes[i]['image']}',
                ),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: Center(
              child: FlatButton(
                  child: Icon(Icons.play_circle_outline, size: 70),
                  onPressed: () {
                    _settingModalBottomSheet(
                        context,
                        '${listRecentes[i]['slug']}',
                        '${listRecentes[i]['title']}');
                  }),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: 40,
                width: 180,
                color: Colors.black54,
                child: ListView(
                  children: <Widget>[
                    Text(
                      "${listRecentes[i]['title']}".substring(0, mid.toInt()) +
                          "..." +
                          "${listRecentes[i]['title']}".substring(
                              "${listRecentes[i]['title']}".length - 6,
                              "${listRecentes[i]['title']}".length),
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
    if (counter == 12) {
      counter = 0;
    }
  }
  return movieList;
}

void _settingModalBottomSheet(context, String link, String title) {
  int quality = 0;
  


  
  Future getVideo() async {
    http.Response response = await http
        .get('http://10.0.2.2:3000/episode/video/$link');
    data = json.decode(response.body);

    videoAnime = data['video'];

    return videoAnime;
  }

  Future getVideoQuality(String link) async {
    http.Response response = await http
        .get('http://10.0.2.2:3000/episode/quality/$link');
    data = json.decode(response.body);

    int num = data['animes'];

    return num;
  }

  getVideo().then((anime) {
    videoAnime = anime;
  });

  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: FutureBuilder(
              future: getVideoQuality(link),
              builder: (_, snapshot) {
                quality = snapshot.data == null ? 0 : quality = snapshot.data;
                if (quality == 0) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    child: Wrap(
                      children: <Widget>[
                        new ListTile(
                            leading: new Icon(Icons.videocam),
                            title: new Text('SD'),
                            onTap: () => {
                                  if (videoAnime.isNotEmpty)
                                    {
                                      Navigator.pop(context),
                                      _showSimpleDialogSD(
                                          context, link, 0, title),
                                    }
                                  else
                                    {Center(child: CircularProgressIndicator())}
                                }),
                        if (quality == 2 || quality == 3)
                          new ListTile(
                              leading: new Icon(Icons.videocam),
                              title: new Text('HD'),
                              onTap: () => {
                                    if (videoAnime.isNotEmpty)
                                      {
                                        Navigator.pop(context),
                                        _showSimpleDialog(
                                            context, link, 1, title),
                                      }
                                    else
                                      {
                                        Center(
                                            child: CircularProgressIndicator())
                                      }
                                  }),
                        if (quality == 3)
                          new ListTile(
                              leading: new Icon(Icons.videocam),
                              title: new Text('Full HD'),
                              onTap: () => {
                                    if (videoAnime.isEmpty)
                                      {
                                        Navigator.pop(context),
                                        Center(
                                            child: CircularProgressIndicator())
                                      }
                                    else
                                      {
                                        _showSimpleDialog(
                                          context,
                                          link,
                                          2,
                                          title,
                                        ),
                                      }
                                  }),
                      ],
                    ),
                  );
                }
              }),
        );
      });
}

void _showSimpleDialog(context, String link, int quality, String title) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _dismissDialog(context);
                navegateToAnimeLifePlayer(context, quality, title);
              },
              child: const Text('AnimeLife Player',
                  style: TextStyle(fontSize: 20)),
            ),
            if (vlcIsInstalled)
              SimpleDialogOption(
                onPressed: () {
                  _dismissDialog(context);
                  vlcPlayer(videoAnime[quality]);
                },
                child: const Text('VLC Player', style: TextStyle(fontSize: 20)),
              ),
            if (mxPlayerIsInstalled)
              SimpleDialogOption(
                onPressed: () {
                  mxPlayer(videoAnime[quality]);
                },
                child: const Text('Mx Player', style: TextStyle(fontSize: 20)),
              ),
          ],
        );
      });
}

void _showSimpleDialogSD(context, String link, int quality, String title) {
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                navegateToAnimeLifePlayer(context, quality, title);
              },
              child: const Text('AnimeLife Player',
                  style: TextStyle(fontSize: 20)),
            ),
            if (vlcIsInstalled)
              SimpleDialogOption(
                onPressed: () {
                  vlcPlayer(videoAnime[quality]);
                  _dismissDialog(context);
                },
                child: const Text('VLC Player', style: TextStyle(fontSize: 20)),
              ),
          ],
        );
      });
}

_dismissDialog(context) {
  Navigator.pop(context);
}

vlcPlayer(String url) async {
  await PlayerPlugin.openWithVlcPlayer(url);
}

mxPlayer(String url) async {
  await PlayerPlugin.openWithMxPlayer(url, "");
}

navegateToAnimeLifePlayer(context, int quality, String title) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Video(
                link: videoAnime[quality],
                title: title,
              )));
}
