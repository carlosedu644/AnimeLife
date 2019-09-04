class Anime {
  String titulo;
  String urlImage;
  String documentId;
  String descricao;
  String numeroDeEpisodios;
  String status;
  String dataLancamento;

  Anime.fromMap(Map<dynamic, dynamic> data)
      : titulo = data["titulo"],
        urlImage = data["capa"],
        documentId = data["documentId"],
        descricao = data["descricao"],
        numeroDeEpisodios = data["numeroDeEpisodios"],
        status = data["status"],
        dataLancamento = data["dataLancamento"];
}
