import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteMain{

  static final SQLiteMain _mainSqlite = SQLiteMain._internal();
  factory SQLiteMain() => _mainSqlite;
  SQLiteMain._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null){
      return _database!;
    }

    await initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    try {
      final getDirectory = await getApplicationDocumentsDirectory();
      String path = join(getDirectory.path, 'db_event.db');
      
      // await deleteDatabase(path);
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          log('Database opened');
        },
      );
      log('Database initialized');
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  void _onCreate(Database db, int version) async {
  try {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS user ('
      'UserID TEXT PRIMARY KEY, ' 
      'EventID TEXT, ' 
      'UserCode TEXT, '  
      'FullName TEXT, '  
      'CCCD TEXT, '   
      'Phone TEXT, '  
      'Email TEXT, '   
      'isCheck TEXT);'   
    );

    await db.execute(
      'CREATE TABLE IF NOT EXISTS event ('
      'EventID TEXT PRIMARY KEY, ' 
      'EventCode TEXT, ' 
      'EventName TEXT);' 
    );
  } catch (e) {
    log('Error creating tables: $e');
    rethrow;
  }
}

}
