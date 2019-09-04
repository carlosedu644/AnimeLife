import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:animelife_firebase/model/Todos.dart';

class DBAnime {
  DBAnime._();

  static final DBAnime db = DBAnime._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todosDb.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Todos ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "image TEXT,"
          "slug TEXT"
          ")");
    });
  }

  newAnime(Anime newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todos");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Todos (id,title,image,slug)"
        " VALUES (?,?,?,?)",
        [id, newClient.title, newClient.image, newClient.slug]);
    return raw;
  }


  updateClient(Anime newClient) async {
    final db = await database;
    var res = await db.update("Todos", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Todos", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Anime.fromMap(res.first) : null;
  }



  Future<List<Anime>> getAllClients() async {
    final db = await database;
    var res = await db.query("Todos");
    List<Anime> list =
        res.isNotEmpty ? res.map((c) => Anime.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Todos", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Todos");
  }
}
