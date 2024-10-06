import 'package:event_management_1/controll/state/statistic_provider.dart';
import 'package:event_management_1/data/model/statistic_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/calculate_statistic_value.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';

class ListUserProvider with ChangeNotifier{
  List<UserModel> _lstUser = [];
  List<UserModel> _filteredUsers = [];

  List<UserModel> get lstUser => _filteredUsers.isEmpty ? _lstUser : _filteredUsers;

  void setList(List<UserModel> lst) {
    _lstUser = lst;
    _filteredUsers = lst;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addList(UserModel user) {
    _lstUser.add(user);
    _filteredUsers.clear();
    notifyListeners();
  }

  void updateUser(UserModel userNew){
    int index = _lstUser.indexWhere((user) => user.phone == userNew.phone);
    if (index != -1) {
      _lstUser[index] = userNew;
      notifyListeners();
    }
  }

  void filterList(String query) {
    if (query.isNotEmpty) {
      // _filteredUsers = _lstUser
      //     .where((user) => user.username.toLowerCase().contains(query.toLowerCase()))
      //     .toList();
       _filteredUsers = _lstUser.where((user) {
        return user.username.toLowerCase().contains(query.toLowerCase()) ||
              user.phone.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } else {
      _filteredUsers.clear();
    }
    notifyListeners();
  }

}