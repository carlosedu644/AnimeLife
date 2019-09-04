// To parse this JSON data, do
//
//     final descricao = descricaoFromJson(jsonString);

import 'dart:convert';

Descricao descricaoFromJson(String str) => Descricao.fromMap(json.decode(str));

String descricaoToJson(Descricao data) => json.encode(data.toMap());

class Descricao {
    List<Description> description;

    Descricao({
        this.description,
    });

    factory Descricao.fromMap(Map<String, dynamic> json) => new Descricao(
        description: new List<Description>.from(json["description"].map((x) => Description.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "description": new List<dynamic>.from(description.map((x) => x.toMap())),
    };
}

class Description {


    String title;
    String image;
    String description;
    String year;
    String episodes;
    String author;
    String slug;

    Description({
        this.title,
        this.image,
        this.description,
        this.year,
        this.episodes,
        this.author,
        this.slug,
    });

    factory Description.fromMap(Map<String, dynamic> json) => new Description(
    
        title: json["title"],
        image: json["image"],
        description: json["description"],
        year: json["year"],
        episodes: json["episodes"],
        author: json["author"],
        slug: json["slug"],
    );

    Map<String, dynamic> toMap() => {
  
        "title": title,
        "image": image,
        "description": description,
        "year": year,
        "episodes": episodes,
        "author": author,
        "slug": slug,
    };
}
