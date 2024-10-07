import 'dart:developer';

import 'package:event_management_1/data/local/main_local.dart';
import 'package:event_management_1/data/model/history_model.dart';

class SQLiteHistory{
  final _sqlite = SQLiteMain();
  final HistoryModelProperty property = HistoryModelProperty();

  Future<void> addHistory(HistoryModel history) async{
    try{
      final db = await _sqlite.database;
      db.rawInsert(
        'INSERT INTO history (${property.dateCreated}, ${property.userId}, ${property.oldStatus}, ${property.newStatus}) VALUES (?, ?, ?, ?)',
        [
          history.dateCreated,
          history.userId,
          history.oldStatus,
          history.newStatus
        ],
      ).then((_) {
        log('Inserted new history with UserID ${history.userId}, NewStatus ${history.newStatus} OldStatus ${history.oldStatus}');
      }).catchError((error) {
        log('Error inserting history: $error');
      });
    }
    catch(e){
      log("$e");
    }
  }

  Future<List<HistoryModel>> getList() async{
    try{
      final db = await _sqlite.database;
      List<Map<String, dynamic>> data = await db.rawQuery('select * from history');
      List<HistoryModel> lst = [];
      if(data.isNotEmpty){
        for (var history in data) {
          lst.add(HistoryModel.fromJson(history)); 
        }
      }
      return lst;
    }
    catch(e){
      log("$e");
      return [];
    }
  }

  Future<void> clearHistory() async{
    try{
      final db = await _sqlite.database;
      await db.rawQuery('delete from history');
    }
    catch(e){
      log("$e");
    }
  }
}