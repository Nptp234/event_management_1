
import 'package:event_management_1/data/model/statistic_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/calculate_statistic_value.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';

class StatisticProvider with ChangeNotifier{
  List<StatisticModel> _lst = [];
  List<StatisticModel> get lstStatistic => _lst;

  void add(StatisticModel user){
    _lst.add(user);
    notifyListeners();
  }

  void setList(List<StatisticModel> lst){
    _lst=[];
    _lst = lst;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  
  StatisticModel setTaskStatistic(Color color, double value, String title, String userState){
    return StatisticModel(color: color, value: value, title: title, userState: userState);
  }

  void setStatisticList(List<UserModel> lstUser){
    List<StatisticModel> lst = [];
    setValueList(lstUser);
    
    Set<String> uniqueStates = <String>{};
    for (var user in lstUser) {
      uniqueStates.add(user.status!);
    }

    for(var state in uniqueStates){
      double value = calculatePercentage(state);
      lst.add(setTaskStatistic(colorState(state), value, "$value%", state));
    }
    setList(lst);
  }

}