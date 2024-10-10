import 'dart:convert';
import 'dart:developer';

import 'package:event_management_1/data/api/const.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:http/http.dart' as http;

class EventApi{

  String? swaggerUrl = "$getSwaggerUrl/events";
  int maxPage = 50;

  Future<List<EventModel>> getList() async{
    int page = 1, totalPage = 1;
    bool hasMoreData = true;
    List<EventModel> lst = [];

    try{
      while(hasMoreData){
        final body = {"query": {}, "page": page, "limit": maxPage, "sort": {}};

        final res = await http.post(
          Uri.parse("$swaggerUrl"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body)
        );

        if(res.statusCode==200){
          final data = jsonDecode(res.body);
          var records = data["data"];
          for(var record in records){
            lst.add(EventModel.fromJson(record));
          }
          totalPage = data["metadata"]["totalPages"];
          if (page < totalPage) {
            page++;
          } else {
            hasMoreData = false;
          }
        }
        else{
          hasMoreData = false;
        }
      }

      return lst;
    }
    catch(e){
      log("$e");
      return [];
    }
  }
}