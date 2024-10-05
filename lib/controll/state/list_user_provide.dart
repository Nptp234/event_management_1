import 'package:event_management_1/data/model/user_model.dart';
import 'package:flutter/material.dart';

class ListUserProvider with ChangeNotifier{
  List<UserModel> _lstUser = [];
  List<UserModel> _filteredUsers = [];

  List<UserModel> get lstUser => _filteredUsers.isEmpty ? _lstUser : _filteredUsers;

  void setList(List<UserModel> lst) {
    _lstUser = lst;
    _filteredUsers.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addList(UserModel user) {
    _lstUser.add(user);
    _filteredUsers.clear();
    notifyListeners();
  }

  void filterList(String query) {
    if (query.isNotEmpty) {
      _filteredUsers = _lstUser
          .where((user) => user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      _filteredUsers.clear();
    }
    notifyListeners();
  }
}