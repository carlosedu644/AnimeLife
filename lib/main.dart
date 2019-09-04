import 'package:animelife_firebase/telas/homeTeste.dart';
import 'package:flutter/material.dart';
import 'package:animelife_firebase/telas/descricao.dart';
import 'package:flutter/painting.dart';
import 'package:animelife_firebase/pesquisa/DataSearch.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wakelock/wakelock.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  runApp(MyApp());
   
}

// status bar color

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final int idx;
  MyApp({this.idx});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return MaterialApp(
      title: 'Pesquisa',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 25.0, fontStyle: FontStyle.italic, color: Colors.black),
        ),
      ),
      home: MyHomePage(
        title: 'Anime Life',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
          ],
        ),
        body: HomeTeste());
  }
}

class DetailPage extends StatefulWidget {
  DetailPage();

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map data;
  List animeData;
  int nextPage;

  navegationToDetail(String slug, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListDescricao(
                  slug: slug,
                  title: title,
                )));
  }



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (animeData == null) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return Container(
        child: StreamBuilder(
            // stream: Firestore.instance.collection("animes").snapshots(),
            builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: animeData == null ? 0 : animeData.length,
              itemBuilder: (_, index) {
                return Card(
                  child: Hero(
                    tag: Text('${animeData[index]['slug']}'),
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          navegationToDetail('${animeData[index]['slug']}',
                              '${animeData[index]['title']}');
                        },
                        child: GridTile(
                          footer: Container(
                            color: Colors.grey.shade900,
                            child: ListTile(
                              title: Text(
                                '${animeData[index]['title']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15.0),
                              ),
                            ),
                          ),
                          child: Image.network('${animeData[index]['image']}',
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }),
      );
    }
  }
}
