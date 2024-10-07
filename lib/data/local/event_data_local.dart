import 'dart:developer';

import 'package:event_management_1/data/local/main_local.dart';
import 'package:event_management_1/data/model/event_model.dart';

class SQLiteEvent{
  final _sqlite = SQLiteMain();
  final EventModelProperty property = EventModelProperty();

  Future<List<EventModel>> getList() async{
    try{
      final db = await _sqlite.database;
      List<Map<String, dynamic>> data = await db.rawQuery('select * from event');
      List<EventModel> lst = [];
      if(data.isNotEmpty){
        for (var user in data) {
          lst.add(EventModel.fromJson(user)); 
        }
      }
      return lst;
    }
    catch(e){
      log("$e");
      return [];
    }
  }

  Future<void> setList(List<EventModel> lst) async{
    try{
      final db = await _sqlite.database;

      await db.transaction((txn) async {
        for (var event in lst) {
          addOrUpdateEvent(event);
        }
      });
    }
    catch(e){
      log("$e");
    }
  }

  void addOrUpdateEvent(EventModel event) {
    _sqlite.database.then((db) {
      db.rawQuery('SELECT * FROM event WHERE ${property.eventId} = ?', [event.eventId]).then((existingEvent) {
        if (existingEvent.isNotEmpty) {
          // Nếu tồn tại, cập nhật sự kiện
          db.rawUpdate(
            'UPDATE event SET ${property.eventCode} = ?, ${property.eventName} = ? WHERE ${property.eventId} = ?',
            [event.eventCode, event.eventName, event.eventId],
          ).then((_) {
            log('Updated event with eventId ${event.eventId}');
          }).catchError((error) {
            log('Error updating event: $error');
          });
        } else {
          // Nếu không tồn tại, thêm sự kiện mới
          db.rawInsert(
            'INSERT INTO event (${property.eventId}, ${property.eventCode}, ${property.eventName}) VALUES (?, ?, ?)',
            [event.eventId, event.eventCode, event.eventName],
          ).then((_) {
            log('Inserted new event with eventId ${event.eventId}');
          }).catchError((error) {
            log('Error inserting event: $error');
          });
        }
      }).catchError((error) {
        log('Error querying event: $error');
      });
    }).catchError((error) {
      log('Error opening database: $error');
    });
  }


}