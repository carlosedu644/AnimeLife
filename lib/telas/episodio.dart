import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mx_player_plugin/mx_player_plugin.dart';
import 'package:animelife_firebase/telas/index.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:device_apps/device_apps.dart';

List videoAnime;
Map vData;
List teste;

class ListEpisodio extends StatefulWidget {
  final String slug;
  final String title;
  ListEpisodio({this.slug, this.title});

  @override
  _ListEpisodioState createState() => _ListEpisodioState();
}

class _ListEpisodioState extends State<ListEpisodio> {
  Map data;
  List animeData;

  List videoData;
  String video;
  int nextPage = 0;
  bool hasNext = true;
  bool hasProgress;
  bool vlcIsInstalled;
  bool mxPlayerIsInstalled;

  ScrollController controller;

  vlcPlayer(String url) async {
    await PlayerPlugin.openWithVlcPlayer(url);
  }

  mxPlayer(String url) async {
    await PlayerPlugin.openWithMxPlayer(url, "");
  }

  _dismissDialog(context) {
    Navigator.pop(context);
  }

  Future getAnimes(int page) async {
    http.Response response = await http
        .get('http://10.0.2.2:3000${widget.slug}/$page');
    data = json.decode(response.body);

    animeData = data['episodes'];
    return animeData;
  }

  Future getNextPage(int page) async {
    http.Response response = await http
        .get('http://10.0.2.2:3000${widget.slug}/$page');
    data = json.decode(response.body);

    setState(() {
      if (data['nextPage'] != false) {
        nextPage = data['nextPage'];
      } else {
        hasNext = data['nextPage'];
      }
    });

    videoData = data['episodes'];
    return videoData;
  }

  @override
  void initState() {
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    getAnimes(1).then((anime) {
      setState(() {
        this.animeData = anime;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    verifyinstalledApps() async {
      vlcIsInstalled =
          await DeviceApps.isAppInstalled('org.videolan.vlc') == null
              ? false
              : vlcIsInstalled =
                  await DeviceApps.isAppInstalled('org.videolan.vlc');
      mxPlayerIsInstalled =
          await DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad') == null
              ? false
              : mxPlayerIsInstalled =
                  await DeviceApps.isAppInstalled('com.mxtech.videoplayer.ad');
    }

    verifyinstalledApps();

    if (animeData == null) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Episodios"),
        ),
        body: Container(
          child: ListView.separated(
              controller: controller,
              separatorBuilder: (context, index) => Divider(),
              itemCount: animeData == null ? 0 : animeData.length,
              itemBuilder: (_, index) {
                return Container(
                  child: ListTile(
                      title: Text(
                        "${animeData[index]['title']}",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onTap: () {
                        _settingModalBottomSheet(
                            context,
                            '${animeData[index]['slug']}',
                            '${animeData[index]['title']}',
                            '${animeData[index]['image']}',
                            index);
                      }),
                );
              }),
        ),
      );
    }
  }

  void _scrollListener() {
    if (hasNext) if (controller.position.extentAfter < 1) {
      getNextPage(nextPage == 0 ? 2 : nextPage).then((next) {
        setState(() {
          print(hasNext);
          for (int i = 0; i < next.length; i++) {
            animeData.add(next[i]);
          }
        });
      });
    }
  }

  void _settingModalBottomSheet(
      context, String link, String title, String image, int index) {
    int quality = 0;



    InterstitialAd myInterstitial = InterstitialAd(
      adUnitId:'ca-app-pub-8648478689251428/3370535737',
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );

    myInterstitial
      ..load()
      ..show();

    Future getVideo() async {
      print("Tilleeeee" + link);
      http.Response response = await http
          .get('http://10.0.2.2:3000/episode/video/$link');
      vData = json.decode(response.body);

      videoAnime = vData['video'];

      return videoAnime;
    }

    getVideo().then((anime) {
      setState(() {
        videoAnime = anime;
      });
    });

    Future getVideoQuality(String link) async {
      http.Response response = await http
          .get('http://10.0.2.2:3000/episode/quality/$link');
      data = json.decode(response.body);

      int num = data['animes'];

      return num;
    }

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
                                        _dismissDialog(context),
                                        _showSimpleDialogSD(
                                            context, link, 0, title, image),
                                      }
                                    else
                                      {
                                        Center(
                                            child: CircularProgressIndicator())
                                      }
                                  }),
                          if (quality == 2 || quality == 3)
                            new ListTile(
                                leading: new Icon(Icons.videocam),
                                title: new Text('HD'),
                                onTap: () => {
                                      if (videoAnime.isNotEmpty)
                                        {
                                          _dismissDialog(context),
                                          _showSimpleDialog(context, link, 1,
                                              title, image, index),
                                        }
                                      else
                                        {
                                          Center(
                                              child:
                                                  CircularProgressIndicator())
                                        }
                                    }),
                          if (quality == 3)
                            new ListTile(
                                leading: new Icon(Icons.videocam),
                                title: new Text('Full HD'),
                                onTap: () => {
                                      if (videoAnime.isEmpty)
                                        {
                                          _dismissDialog(context),
                                          Center(
                                              child:
                                                  CircularProgressIndicator())
                                        }
                                      else
                                        {
                                          _showSimpleDialog(context, link, 2,
                                              title, image, index),
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

  void _showSimpleDialog(context, String link, int quality, String title,
      String image, int index) {
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
                  child:
                      const Text('VLC Player', style: TextStyle(fontSize: 20)),
                ),
              if (mxPlayerIsInstalled)
                SimpleDialogOption(
                  onPressed: () {
                    _dismissDialog(context);
                    mxPlayer(videoAnime[quality]);
                  },
                  child:
                      const Text('Mx Player', style: TextStyle(fontSize: 20)),
                ),
            ],
          );
        });
  }

  void _showSimpleDialogSD(
      context, String link, int quality, String title, String image) {
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
                  child:
                      const Text('VLC Player', style: TextStyle(fontSize: 20)),
                ),
            ],
          );
        });
  }
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
