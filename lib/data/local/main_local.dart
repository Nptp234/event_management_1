import 'dart:developer';

import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/data/model/history_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteMain{

  static final SQLiteMain _mainSqlite = SQLiteMain._internal();
  factory SQLiteMain() => _mainSqlite;
  SQLiteMain._internal();

  final UserModelProperty userProperty = UserModelProperty();
  final EventModelProperty eventProperty = EventModelProperty();
  final HistoryModelProperty historyProperty = HistoryModelProperty();

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
        '${userProperty.userId} TEXT PRIMARY KEY, ' 
        '${userProperty.eventId} TEXT, ' 
        '${userProperty.userCode} TEXT, '  
        '${userProperty.fullname} TEXT, '  
        '${userProperty.cccd} TEXT, '   
        '${userProperty.phone} TEXT, '  
        '${userProperty.email} TEXT, '   
        '${userProperty.status} TEXT);'   
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS event ('
        '${eventProperty.eventId} TEXT PRIMARY KEY, ' 
        '${eventProperty.eventCode} TEXT, ' 
        '${eventProperty.eventName} TEXT);' 
      );

      await db.execute(
        'CREATE TABLE IF NOT EXISTS history ('
        '${historyProperty.historyId} INTEGER PRIMARY KEY AUTOINCREMENT, ' 
        '${historyProperty.dateCreated} TEXT, ' 
        '${historyProperty.userId} TEXT, '
        '${historyProperty.oldStatus} TEXT, '
        '${historyProperty.newStatus} TEXT);'
      );


    } catch (e) {
      log('Error creating tables: $e');
      rethrow;
    }
  }

}
