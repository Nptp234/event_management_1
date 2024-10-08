import 'dart:developer';

import 'package:event_management_1/data/local/main_local.dart';
import 'package:event_management_1/data/model/user_model.dart';

class SQLiteUser{
  final _sqlite = SQLiteMain();
  final UserModelProperty property = UserModelProperty();

  Future<List<UserModel>> getList() async{
    try{
      final db = await _sqlite.database;
      List<Map<String, dynamic>> data = await db.rawQuery('select * from user');
      List<UserModel> lst = [];
      if(data.isNotEmpty){
        for (var user in data) {
          lst.add(UserModel.fromJson(user)); 
        }
      }
      return lst;
    }
    catch(e){
      log("$e");
      return [];
    }
  }

  Future<void> setList(List<UserModel> lst) async{
    try{
      final db = await _sqlite.database;

      await db.transaction((txn) async {
        for (var user in lst) {
          addOrUpdateUser(user);
        }
      });
    }
    catch(e){
      log("$e");
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      final db = await _sqlite.database;
      int count = await db.rawUpdate(
        'UPDATE user SET ${property.eventId} = ?, ${property.userCode} = ?, ${property.fullname} = ?, ${property.cccd} = ?, ${property.phone} = ?, ${property.email} = ?, ${property.status} = ?, ${property.facility} = ?, ${property.office} = ?, ${property.desciption} = ?, ${property.userUpdate} = ?, ${property.dateUpdate} = ? WHERE ${property.userId} = ?',
        [
          user.eventId,
          user.userCode,
          user.fullname,
          user.cccd,
          user.phone,
          user.email,
          user.status,
          user.facility,
          user.office,
          user.desciption,
          user.userUpdate,
          user.dateUpdate,
          user.userId
        ],
      );
      return count > 0;
    } catch (e) {
      log("$e");
      return false;
    }
  }

  void addOrUpdateUser(UserModel user) {
    _sqlite.database.then((db) {
      db.rawQuery('SELECT * FROM user WHERE ${property.userId} = ?', [user.userId]).then((existingUser) {
        if (existingUser.isNotEmpty) {
          db.rawUpdate(
            'UPDATE user SET ${property.eventId} = ?, ${property.userCode} = ?, ${property.fullname} = ?, ${property.cccd} = ?, ${property.phone} = ?, ${property.email} = ?, ${property.status} = ?, ${property.facility} = ?, ${property.office} = ?, ${property.desciption} = ?, ${property.userUpdate} = ?, ${property.dateUpdate} = ? WHERE ${property.userId} = ?',
            [
              user.eventId,
              user.userCode,
              user.fullname,
              user.cccd,
              user.phone,
              user.email,
              user.status,
              user.facility,
              user.office,
              user.desciption,
              user.userUpdate,
              user.dateUpdate,
              user.userId
            ],
          ).then((_) {
            log('Updated user with UserID ${user.userId}');
          }).catchError((error) {
            log('Error updating user: $error');
          });
        } else {
          db.rawInsert(
            'INSERT INTO user (${property.userId}, ${property.eventId}, ${property.userCode}, ${property.fullname}, ${property.cccd}, ${property.phone}, ${property.email}, ${property.status}, ${property.facility}, ${property.office}, ${property.desciption}, ${property.userCreate}, ${property.dateCreate}, ${property.dateUpdate}) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
            [
              user.userId,
              user.eventId,
              user.userCode,
              user.fullname,
              user.cccd,
              user.phone,
              user.email,
              user.status,
              user.facility,
              user.office,
              user.desciption,
              user.userCreate,
              user.dateCreate,
              user.dateUpdate
            ],
          ).then((_) {
            log('Inserted new user with UserID ${user.userId}');
          }).catchError((error) {
            log('Error inserting user: $error');
          });
        }
      }).catchError((error) {
        log('Error querying user: $error');
      });
    }).catchError((error) {
      log('Error opening database: $error');
    });
  }



}