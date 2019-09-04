// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

Client clientFromJson(String str) => Client.fromMap(json.decode(str));

String clientToJson(Client data) => json.encode(data.toMap());

class Client {
    List<Favorite> favorite;

    Client({
        this.favorite,
    });

    factory Client.fromMap(Map<String, dynamic> json) => new Client(
        favorite: new List<Favorite>.from(json["favorite"].map((x) => Favorite.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "favorite": new List<dynamic>.from(favorite.map((x) => x.toMap())),
    };
}

class Favorite {
    int id;
    String title;
    String image;
    String slug;

    Favorite({
        this.id,
        this.title,
        this.image,
        this.slug,
    });

    factory Favorite.fromMap(Map<String, dynamic> json) => new Favorite(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        slug: json["slug"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": image,
        "slug": slug,
    };
}
