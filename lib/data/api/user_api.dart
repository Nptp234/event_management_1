import 'dart:convert';
import 'dart:developer';

import 'package:event_management_1/data/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserApi{

  String? key = dotenv.env["PUBLIC_KEY"];
  String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['USER_TABLE_ID']}";

  Future<String> getRecordId(String userId) async{
    try{
      final res = await http.get(
        Uri.parse('$baseUrl?filterByFormula={UserID}="$userId"'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json'
        },
      );
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        if(data['records'].isNotEmpty){
          return data['records'][0]['id'];
        }else{return '';}
      }else {return '';}
    }
    catch(e){
      log("$e");
      return '';
    }
  }

  Future<List<UserModel>> getList() async{
    try{
      final res = await http.get(
        Uri.parse(baseUrl!),
        headers: {"Authorization": "Bearer $key", "Content-Type": "application/json"}
      );
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        List<UserModel> lst = [];
        var records = data["records"];
        for(var record in records){
          var field = record["fields"];
          lst.add(UserModel.fromJson(field));
        }
        return lst;
      }
      return [];
    }
    catch(e){
      log("$e");
      return [];
    }
  }

  Future<bool> updateStatusUser(UserModel user) async{
    try{
      String recordId = await getRecordId(user.userId!);
      final body = {
        "records":[
            {
              "id": recordId,
              "fields":{
                "isCheck": user.status
              }
            }
        ]
      };

      final res = await http.patch(
        Uri.parse(baseUrl!),
        headers: {"Authorization": "Bearer $key", "Content-Type": "application/json"},
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