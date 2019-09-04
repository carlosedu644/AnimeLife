// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromMap(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toMap());

class Welcome {
  int length;
  int nextPage;
  List<Anime> animes;

  Welcome({
    this.length,
    this.nextPage,
    this.animes,
  });

  factory Welcome.fromMap(Map<String, dynamic> json) => new Welcome(
        length: json["length"],
        nextPage: json["nextPage"],
        animes:
            new List<Anime>.from(json["animes"].map((x) => Anime.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "length": length,
        "nextPage": nextPage,
        "animes": new List<dynamic>.from(animes.map((x) => x.toMap())),
      };
}

class Anime {
  int id;
  String title;
  String image;
  String slug;

  Anime({
    this.id,
    this.title,
    this.image,
    this.slug,
  });

  factory Anime.fromMap(Map<String, dynamic> json) => new Anime(
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
