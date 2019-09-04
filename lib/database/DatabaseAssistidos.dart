import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:animelife_firebase/model/ContinuarAssistindo.dart';

class DBAssistidos {
  DBAssistidos._();

  static final DBAssistidos db = DBAssistidos._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "AssistidosDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Assistidos ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "image TEXT,"
          "time INT,"
          "slug TEXT"
          ")");
    });
  }

  newClient(ContinuarAssistindo newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Assistidos");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Assistidos (id,title,image,time,slug)"
        " VALUES (?,?,?,?,?)",
        [id, newClient.title, newClient.image, newClient.time,newClient.slug]);
    return raw;
  }


  updateClient(ContinuarAssistindo newClient) async {
    final db = await database;
    var res = await db.update("Assistidos", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  getClient(int id) async {
    final db = await database;
    var res = await db.query("Assistidos", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ContinuarAssistindo.fromMap(res.first) : null;
  }



  Future<List<ContinuarAssistindo>> getAllAssistidos() async {
    final db = await database;
    var res = await db.query("Assistidos");
    List<ContinuarAssistindo> list =
        res.isNotEmpty ? res.map((c) => ContinuarAssistindo.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(int id) async {
    final db = await database;
    return db.delete("Assistidos", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Assistidos");
  }
}
