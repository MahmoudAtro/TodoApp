import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "mahmoud.db");
    Database mydb = await openDatabase(path, onCreate: _oncreate , version: 1);
    return mydb;
  }

  _oncreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE "todo" (
      "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
      "title"	TEXT NOT NULL,
      "color"	INTEGER NOT NULL,
      "icon" TEXT NOT NULL,
      "date" TEXT NOT NULL,
      "check" INTEGER NOT NULL
    )
''');
    print("create database and table==========================");
  }

  read() async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query("todo");
    return response;
  }

  insert(Map<String, Object?> value) async {
    Database? mydb = await db;
    int response = await mydb!.insert("todo", value);
    return response;
  }

  update(Map<String, Object?> value, String? where) async {
    Database? mydb = await db;
    int response = await mydb!.update("todo", value, where: where);
    return response;
  }

  delete(String? where) async {
    Database? mydb = await db;
    int response = await mydb!.delete("todo", where: where);
    return response;
  }


  // delete dataBase
  // deletedatabase() async {
  //   String dbPath = await getDatabasesPath();
  //   String path = join(dbPath, "mahmoud.db");
  //   await deleteDatabase(path);
  // }
}
