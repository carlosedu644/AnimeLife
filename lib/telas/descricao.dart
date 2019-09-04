import 'package:animelife_firebase/model/FavModel.dart';
import 'package:flutter/material.dart';
import 'package:animelife_firebase/telas/episodio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animelife_firebase/database/Database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

bool alreadysaved;
bool alreadycached = false;
List<String> cached = new List<String>();
List<String> teste;

class ListDescricao extends StatefulWidget {
  final String slug;
  final String title;
  final int id;
  ListDescricao({this.slug, this.title, this.id});

  final TextStyle bottomMenuStyle =
      TextStyle(fontSize: 12, color: Colors.white);
  final TextStyle topMenuStyle = TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.white70);

  @override
  _ListDescricaoState createState() => _ListDescricaoState();
}

class _ListDescricaoState extends State<ListDescricao> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Map data;
  Map data2;
  Map<String, dynamic> animeData = new Map();
  Map animeDescripton;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getListFavoritos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    teste = prefs.getStringList('lista_favoritos') ?? [];
    return teste;
  }

  Future getAnimes() async {
    http.Response response =
        await http.get('http://10.0.2.2:3000${widget.slug}');
    //data = json.decode(response.body);

    String body = utf8.decode(response.bodyBytes);
    print(body);
    data = json.decode(body);

    animeData = data['data'];

    return animeData;
  }

  Future getDescription() async {
    data = json.decode(cached[0]);
    animeData = data['data'];

    return animeData;
  }

  @override
  void initState() {
    super.initState();

    getListFavoritos().then((fav) {
      setState(() {
        teste = fav;
        if (teste != null) {}
      });
    });

    getAnimes().then((anime) {
      setState(() {
        this.animeData = anime;
      });
    });
  }

  navegateToEpisodio(String slug, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListEpisodio(
                  slug: slug,
                  title: title,
                )));
  }

  @override
  Widget build(BuildContext context) {
    if (animeData.isEmpty) {
      return new Center(child: new CircularProgressIndicator());
    }

    final logo = Hero(
      tag: '${widget.slug}',
      child: Container(
        height: 450,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: new CachedNetworkImageProvider('${animeData['image']}'),
          fit: BoxFit.fill,
        )),
        child: Column(
          children: <Widget>[
            SizedBox(height: 130),
            FlatButton(
              child: Icon(
                Icons.play_circle_outline,
                size: 200,
                color: Colors.white54,
              ),
              onPressed: () async {
                navegateToEpisodio('${widget.slug}', '${widget.title}');
              },
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 35, 0, 0),
              height: 120,
              width: 1080,
              color: Colors.black54,
              child: Column(
                children: <Widget>[
                  Text(
                    "Ano: ${animeData['year']}",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Episodios: ${animeData['episodes']}',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Autor: ${animeData['author']}',
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // );
    if (teste != null) {
      alreadysaved = teste.contains('${widget.title}');
    }

    final addFavoritos = FlatButton(
        child: Column(
          children: <Widget>[
            Icon(
              alreadysaved ? Icons.delete : Icons.add,
            ),
            Text(
              alreadysaved
                  ? "Remover da lista da minha lista"
                  : "Adiconar a minha lista",
              style: widget.bottomMenuStyle,
            )
          ],
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();

          setState(() {
            if (alreadysaved) {
              var myStringList = prefs.getStringList('lista_favoritos') ?? [];

              if (myStringList.contains('${widget.title}')) {
                myStringList.remove('${widget.title}');
                DBProvider.db.deleteClient(widget.id);
                prefs.setStringList('lista_favoritos', myStringList);
              }
            } else {
              // List<String> listafav = new List();
              if (!teste.contains('${widget.title}')) {
                teste.add('${widget.title}');
                prefs.setStringList('lista_favoritos', teste);
                addNewFavorite();
              }
            }
          });
        });

    if (animeData == null) {
      return Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              logo,
              SizedBox(height: 20.0),
              addFavoritos,
              SizedBox(height: 20.0),
              Text(
                '${animeData['description']}',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      );
    }
  }

  addNewFavorite() async {
    List<Favorite> newFav = [
      Favorite(
          title: '${widget.title}',
          image: '${animeData['image']}',
          slug: '${widget.slug}'),
    ];
    Favorite fav = newFav[0];
    await DBProvider.db.newClient(fav);
  }
}
