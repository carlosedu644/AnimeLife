// To parse this JSON data, do
//
//     final descricao = descricaoFromJson(jsonString);

import 'dart:convert';

Descricao descricaoFromJson(String str) => Descricao.fromMap(json.decode(str));

String descricaoToJson(Descricao data) => json.encode(data.toMap());

class Descricao {
    List<ContinuarAssistindo> continuarAssistindo;

    Descricao({
        this.continuarAssistindo,
    });

    factory Descricao.fromMap(Map<String, dynamic> json) => new Descricao(
        continuarAssistindo: new List<ContinuarAssistindo>.from(json["continuarAssistindo"].map((x) => ContinuarAssistindo.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "continuarAssistindo": new List<dynamic>.from(continuarAssistindo.map((x) => x.toMap())),
    };
}

class ContinuarAssistindo {
    int id;
    String title;
    String image;
    double time;
    String slug;

    ContinuarAssistindo({
        this.id,
        this.title,
        this.image,
        this.time,
        this.slug,
    });

    factory ContinuarAssistindo.fromMap(Map<String, dynamic> json) => new ContinuarAssistindo(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        time: json["time"],
        slug: json["slug"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "image": image,
        "time": time,
        "slug": slug,
    };
}
