import 'package:event_management_1/controll/state/statistic_provider.dart';
import 'package:event_management_1/data/model/statistic_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/calculate_statistic_value.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';

class ListUserProvider with ChangeNotifier{
  List<UserModel> _lstUser = [];
  List<UserModel> _filteredUsers = [];
  String? _eventIdFilter, eventName;
  String _searchQuery = '';

  List<UserModel> get lstUser => _filteredUsers.isEmpty ? [] : _filteredUsers;
  List<UserModel> get lstUserMain => _lstUser;

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

  // void filterListSearch(String query) {
  //   if (query.isNotEmpty) {
  //      _filteredUsers = _lstUser.where((user) {
  //       return user.fullname!.toLowerCase().contains(query.toLowerCase()) ||
  //             user.phone!.toLowerCase().contains(query.toLowerCase()) ||
  //             user.email!.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   } else {
  //     _filteredUsers.clear();
  //   }
  //   notifyListeners();
  // }

  // void filterListEventID(String query) {
  //   _filteredUsers = _lstUser.where((user) {
  //     final bool matchesDropdown = user.eventId == query;
  //     return matchesDropdown; 
  //   }).toList();

  //   notifyListeners();
  // }

  void _filterUsers() {
    _filteredUsers = _lstUser.where((user) {
      final bool matchesSearch = user.fullname!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                 user.phone!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                                 user.email!.toLowerCase().contains(_searchQuery.toLowerCase());

      final bool matchesEventId = _eventIdFilter == null || user.eventId == _eventIdFilter;

      return matchesSearch && matchesEventId;
    }).toList();
    notifyListeners();
  }

  void filterListSearch(String query) {
    _searchQuery = query;
    _filterUsers();
  }

  void filterListEventID(String eventId) {
    _eventIdFilter = eventId.isEmpty ? null : eventId;
    _filterUsers();
  }

  void setEventName(String name){
    eventName = name;
    notifyListeners();
  }

}