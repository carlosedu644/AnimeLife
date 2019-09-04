import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animelife_firebase/telas/descricao.dart';

Widget makePopularWidget(String title, BuildContext context, List animeData) {
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
            children: makeContainers(animeData, context),
          ),
          //     }
          // ),
        )
      ],
    ),
  );
}

List<Widget> makeContainers(List animeData, BuildContext context) {
 
  List<Container> movieList = [];
  for (var i = 0; i < animeData.length; i++) {
    if(animeData[i]['image'] != Error)
    movieList.add(Container(
      padding: EdgeInsets.only(left: 5, right: 10),
      width: 155,
      
      child: Column(
        children: <Widget>[
          InkWell(
              child: Stack(
                children: <Widget>[
                  new Center(
                    
                  child:CachedNetworkImage(     
                    imageUrl: '${animeData[i]['image']}',
                    placeholder: (context, url) =>
                        Image.asset("assets/original.gif"),
                        errorWidget:  (context,erro, url)=>Image.asset('assets/404gif.gif'),
                        fit: BoxFit.fill,
                   
                 
                  )),

                  
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "${animeData[i]['title']}".replaceAll("-", " "),
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListDescricao(
                            slug: '${animeData[i]['slug']}',
                            title: '${animeData[i]['title']}',
                          )))),
        ],
      ),
    ));
  }
  return movieList;
}
