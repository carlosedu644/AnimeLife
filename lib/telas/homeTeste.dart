import 'package:animelife_firebase/model/FavModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animelife_firebase/database/Database.dart';
import 'dart:math';
import 'package:animelife_firebase/Widgets/maisAssistidos.dart';
import 'package:animelife_firebase/Polulares/populares.dart';
import 'package:animelife_firebase/Widgets/EpNovos.dart';
import 'package:animelife_firebase/Widgets/sugetaoAssistir.dart';
import 'package:animelife_firebase/Widgets/favoritosAssistir.dart';
import 'package:device_id/device_id.dart';


Map data;
Map recentes;
List teste;

List<Map<String, dynamic>> listDescription = new List();
int nextPage;
int lengthtodos;
int lengthepisodes;
final rng = new Random();

class Home extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 25.0, fontStyle: FontStyle.italic, color: Colors.black),
        ),
      ),
      home: HomeTeste(),
    );
  }
}

class HomeTeste extends StatefulWidget {
  @override
  _HomeTesteState createState() => _HomeTesteState();
}

class _HomeTesteState extends State<HomeTeste> {
  int page = rng.nextInt(158);

  List animeData = new List();
  List listRecentes = new List();

  Future getAnimes(String page) async {
    var res = await http.get('http://10.0.2.2:3000/todos/$page');

    if (res.statusCode == 200) {
      data = json.decode(res.body);
      animeData = data['animes'];
      return animeData;
    }
  }

  Future getRecentes() async {
    var res = await http.get('http://10.0.2.2:3000/episodes');

    if (res.statusCode == 200) {
      recentes = json.decode(res.body);
      listRecentes = recentes['episodes'];
      return listRecentes;
    }
  }

  Future getDeviceId() async {
    return await DeviceId.getID;
  }

  @override
  void initState() {
 
    super.initState();

    getRecentes().then((episodio) {
      setState(() {
        listRecentes = episodio;
      });
    });

    getAnimes(page.toString()).then((anime) {
      setState(() {
        animeData = anime;
      });
    });
    getDeviceId().then((id) {
      deviceId = id;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body: Container(
      child: FutureBuilder<List<Favorite>>(
          future: DBProvider.db.getAllClients(),
          builder: (_, snapshot) {
            if (animeData == null || listRecentes == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                          // child: new Swiper(
                          //   itemBuilder: (BuildContext context, int index) {
                          //     return new Image.network(
                          //       '${popular[index]['image']}',
                          //       fit: BoxFit.fill,
                          //     );
                          //   },
                          //   onTap: (int index) => Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => ListDescricao(
                          //                 title: '${popular[index]['title']}',
                          //                 slug: '${popular[index]['slug']}',
                          //               ))),
                          //   duration: 2,
                          //   autoplay: true,
                          //   itemCount: popular.length,
                          //   viewportFraction: 0.5,
                          //   scale: 0.9,
                          // )
                        ),

                        makeContinueWatching("Últimos episodios adicionados",
                            listRecentes, context),

                        if (snapshot.data != null && snapshot.data.isNotEmpty)
                          makeFavoriteWidget(
                              "Meus favoritos", context, snapshot, animeData),
                        SizedBox(
                          height: 20,
                        ),
                        makeMaisAssistidosWidget("Populares", context, popular),
                        SizedBox(
                          height: 20,
                        ),
                        makePopularWidget(
                            "Sugestão de animes", context, animeData),
                        SizedBox(
                          height: 20,
                        ),
                        // makeEpisodioWidget(
                        //     "Últimos episodios adicionados", context),
                      ],
                    );
                  });
            }
          }),
    ));
  }
}


