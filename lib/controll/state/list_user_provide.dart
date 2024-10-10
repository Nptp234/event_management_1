
import 'package:event_management_1/data/model/user_model.dart';
import 'package:flutter/material.dart';

class ListUserProvider with ChangeNotifier{
  List<UserModel> _lstUser = [];
  List<UserModel> _filteredUsers = [];
  String? eventIdFilter, eventName;
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
    int index = _lstUser.indexWhere((user) => user.userId == userNew.userId);
    if (index != -1) {
      _lstUser[index] = userNew;
      notifyListeners();
    }
  }

  void _filterUsers() {
    _filteredUsers = _lstUser.where((user) {
      final bool matchesSearch = _searchQuery.isEmpty || _searchQuery=="" ||
                                user.fullname!.toLowerCase().trim().contains(_searchQuery.toLowerCase().trim()) ||
                                 user.phone!.toLowerCase().trim().contains(_searchQuery.toLowerCase().trim()) ||
                                 user.email!.toLowerCase().trim().contains(_searchQuery.toLowerCase().trim());

      final bool matchesEventId = eventIdFilter == null || user.eventId == eventIdFilter;

      return matchesSearch && matchesEventId;
    }).toList();
    notifyListeners();
  }

  void filterListSearch(String query) {
    _searchQuery = query;
    _filterUsers();
  }

  void filterListEventID(String eventId) {
    eventIdFilter = eventId.isEmpty ? null : eventId;
    _filterUsers();
  }

  void setEventName(String name){
    eventName = name;
    notifyListeners();
  }

}