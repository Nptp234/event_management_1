import 'dart:convert';
import 'dart:developer';

import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/const.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserApi{

  // String? key = dotenv.env["PUBLIC_KEY"];
  // String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['USER_TABLE_ID']}";
  
  String? swaggerUrl = "$getSwaggerUrl/users";
  int maxPage = 50;

  Future<List<UserModel>> getFullList() async {
    List<UserModel> fullList = [];
    int page = 1;
    bool hasMoreData = true;

    try {
      while (hasMoreData) {
        final body = {"query": {}, "page": page, "limit": maxPage, "sort": {}};

        final res = await http.post(
          Uri.parse("$swaggerUrl"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          List<UserModel> lst = [];
          var records = data["data"];
          for (var record in records) {
            lst.add(UserModel.fromJson(record));
          }

          fullList.addAll(lst);

          if (records.length < maxPage) {
            hasMoreData = false;
          } else {
            page++; 
          }
        } else {
          hasMoreData = false; 
        }
      }

      return fullList;
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