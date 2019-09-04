import 'package:animelife_firebase/telas/descricao.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataSearch extends SearchDelegate<String> {
  bool flag = false;

  // List<AnimeTeste> aux;

  List suggestionList;
  Map data;
  List animeData = new List();
  Future getAnimes() async {
    http.Response response =
        await http.get('https://10.0.2.2:3000/pesquisa/$query');
    data = json.decode(response.body);

    animeData = data['search'];
    flag = true;
    return animeData;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getAnimes(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(
                  child: new CircularProgressIndicator(),
                );
            } else {
              animeData = snapshot.data;
              return ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: animeData.length == null ? 0 : animeData.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(animeData[index]['title']
                          .toString()
                          .replaceAll("-", " ")),
                      onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListDescricao(
                                    title: animeData[index]['title'],
                                    slug: animeData[index]['slug'],
                                  ),
                            ),
                          ),
                    );
                  });
            }
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(child: Center());
  }
}
