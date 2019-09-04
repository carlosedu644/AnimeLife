import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animelife_firebase/model/FavModel.dart';
import 'package:animelife_firebase/telas/descricao.dart';


Widget makeFavoriteWidget(
    String title, BuildContext context, AsyncSnapshot post, List animeData) {
  return Container(
    padding: EdgeInsets.only(left: 5, right: 5),
    height: 240,
    child: Column(
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold))
            ],
          ),
        ),
        Container(
          height: 180,

          child: ListView(
            padding: EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            children: favoriteContainers(animeData, context, post),
          ),
          //     }
          // ),
        )
      ],
    ),
  );
}

List<Widget> favoriteContainers(
    List animeData, BuildContext context, AsyncSnapshot post) {
  List<Container> movieList = [];
  for (var i = 0; i < post.data.length; i++) {
    Favorite item = post.data[i];
    movieList.add(Container(
      padding: EdgeInsets.only(left: 5, right: 10),
      width: 155,
      child: Column(
        children: <Widget>[
          InkWell(
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: '${item.image}',
                    placeholder: (context, url) =>
                        new CircularProgressIndicator(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                  Container(
                    color: Colors.black54,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "${item.title}".replaceAll("-", " "),
                          style: TextStyle(color: Colors.white, fontSize: 15.0),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListDescricao(
                          slug: '${item.slug}',
                          title: '${item.title}',
                          id: item.id)))),
        ],
      ),
    ));
  }
  return movieList;
}
