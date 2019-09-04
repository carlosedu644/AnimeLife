class AnimesFavoritos {
  String capa;
  String documentId;
  String titulo;

  AnimesFavoritos.fromMap(Map<dynamic, dynamic> data)
      : capa = data["capa"],
        documentId = data["documentId"],
        titulo = data['titulo'];
}