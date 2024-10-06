import 'package:event_management_1/data/model/event_model.dart';
import 'package:flutter/material.dart';

class ListEventProvider with ChangeNotifier{
  List<EventModel> _lstEvent = [];
  List<EventModel> get lstEvent => _lstEvent;

  void setList(List<EventModel> lst){
    _lstEvent = lst;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addList(EventModel event){
    _lstEvent.add(event);
    notifyListeners();
  }
  
}