import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'photo_idea.db'),
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE saved  (
        id INTEGER PRIMARY KEY,
        src TEXT
        ); 
        ''');
      },
      version: 1,
    );
  }
}
