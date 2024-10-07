import 'dart:convert';
import 'dart:developer';

import 'package:event_management_1/data/model/event_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EventApi{
  String? key = dotenv.env["PUBLIC_KEY"];
  String? baseUrl = "https://api.airtable.com/v0/${dotenv.env['BASE_ID']}/${dotenv.env['EVENTS_TABLE_ID']}";

  Future<List<EventModel>> getList() async{
    try{
      final res = await http.get(
        Uri.parse(baseUrl!),
        headers: {"Authorization": "Bearer $key", "Content-Type": "application/json"}
      );
      if(res.statusCode==200){
        final data = jsonDecode(res.body);
        List<EventModel> lst = [];
        var records = data["records"];
        for(var record in records){
          var field = record["fields"];
          lst.add(EventModel.fromJson(field));
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
}