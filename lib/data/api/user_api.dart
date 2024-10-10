import 'dart:convert';
import 'dart:developer';

import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/const.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserApi{
  
  String? swaggerUrl = "$getSwaggerUrl/users";
  int maxPage = 50;

  Future<List<UserModel>> _getList(Map<dynamic, dynamic> body) async{
    List<UserModel> fullList = [];
    int page = 1, totalPage = 1;
    bool hasMoreData = true;

    try{
      while(hasMoreData){
        body["page"] = page;
        final res = await http.post(
          Uri.parse("$swaggerUrl"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          var records = data["data"];
          for (var record in records) {
            fullList.add(UserModel.fromJson(record));
          }

          totalPage = data["metadata"]["totalPages"];
          if (page < totalPage) {
            page++;
          } else {
            hasMoreData = false;
          }
        } else {
          hasMoreData = false; 
        }
      }
      return fullList;
    }
    catch(e){
      log("$e");
      return [];
    }
  }

  Future<List<UserModel>> getFullList() async {
    List<UserModel> fullList = [];
    final body = {"query": {}, "page": 1, "limit": maxPage, "sort": {}};

    try {
      fullList = await _getList(body);
      return fullList;
    } catch (e) {
      log("$e");
      return [];
    }
  }

  Future<List<UserModel>> getListWithEventID(int eventId) async{
    List<UserModel> lst = [];
    final body = {"query": {"eventId": eventId}, "page": 1, "limit": maxPage, "sort": {}};

    try {
      lst = await _getList(body);
      return lst;
    } catch (e) {
      log("$e");
      return [];
    }
  }


  Future<bool> updateStatusUser(String userId, String userStatus, BuildContext context) async{
    try{
      final userProvider = Provider.of<ListUserProvider>(context, listen: false);
      UserModel userModel = userProvider.lstUserMain.firstWhere((user)=>user.userId==userId);
      
      final body = {
        "userCode": "${userModel.userCode}",
        "fullName": "${userModel.fullname}",
        "cccd": "${userModel.cccd}",
        "phone": "${userModel.phone}",
        "facility": "${userModel.facility}",
        "office": "${userModel.office}",
        "email": "${userModel.email}",
        "isCheck": userStatus==userState(1)?1:0,
        "description": "${userModel.desciption}",
        "userCreated": "${userModel.userCreate}",
        "userUpdated": "${userModel.userUpdate}",
        "dateCreated": "${userModel.dateCreate}",
        "dateUpdated": DateTime.now().toIso8601String(),
        "eventID": int.parse(userModel.eventId!)
      };
      
      final res = await http.put(
        Uri.parse("$swaggerUrl/{id}?userID=${int.parse(userId)}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body)
      );
      return res.statusCode==200;
    }
    catch(e){
      log("$e");
      return false;
    }
  }

}