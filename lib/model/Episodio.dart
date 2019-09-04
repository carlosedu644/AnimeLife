class Episodio {
  String link;
  String epName;

  Episodio.fromMap(Map<dynamic, dynamic> data)
      : link = data["link"],
        epName = data["epName"];
}