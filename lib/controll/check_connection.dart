
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_management_1/controll/data/fetch_data.dart';
import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/local/event_data_local.dart';
import 'package:event_management_1/data/local/history_data_local.dart';
import 'package:event_management_1/data/local/user_data_local.dart';
import 'package:event_management_1/data/model/history_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

Future<bool> checkInternetConnection() async{
  var connectResult = await (Connectivity().checkConnectivity());
  return connectResult.contains(ConnectivityResult.mobile) || connectResult.contains(ConnectivityResult.wifi);
}


class ConnectivityService {
  Stream<List<ConnectivityResult>> get onConnectivityChanged => (Connectivity().onConnectivityChanged);
  
  final SQLiteUser sqLiteUser = SQLiteUser();
  final SQLiteEvent sqLiteEvent = SQLiteEvent();
  final SQLiteHistory sqLiteHistory = SQLiteHistory();
  final UserApi userApi = UserApi();
  bool _hasInitialCheckRun = false;

  int _retryCount = 0;
  final int _maxRetries = 3;

  void monitorConnection(BuildContext context) {
    onConnectivityChanged.listen(
      (result) async{
        if(_hasInitialCheckRun){
          bool isConnect = await checkInternetConnection();
          if(isConnect){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đã có mạng trở lại, quá trình đồng bộ sẽ tự động bắt đầu!'),
                backgroundColor: Colors.red,
                padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
              ),
            );
            await _actionWhenHaveConnect(context);
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mất kết nối, sẽ tự động chuyển sang sử dụng lưu trữ cục bộ!'),
                backgroundColor: Colors.red,
                padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
              ),
            );
            await _actionWhenLostConnect(context);
          }
        }else{
          _hasInitialCheckRun=true;
        }
      }
    );
  }

  Future<void> _actionWhenLostConnect(BuildContext context) async{
    try{
      final userProvider = Provider.of<ListUserProvider>(context, listen: false);
      final eventProvider = Provider.of<ListEventProvider>(context, listen: false);
      await sqLiteUser.setList(userProvider.lstUserMain);
      await sqLiteEvent.setList(eventProvider.lstEvent);
    }
    catch(e){
      log("$e");
    }
  }

  Future<void> _actionWhenHaveConnect(BuildContext context) async{
    try{
      bool isConnect = await checkInternetConnection();
      if(isConnect){
        bool isAsync = await asyncData(context);
        if (isAsync) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã đồng bộ thành công!'),
              backgroundColor: mainColor,
              padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
            ),
          );
          await sqLiteHistory.clearHistory();
          _retryCount = 0;
        } else {
          if(_retryCount < _maxRetries){
            _retryCount++;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đồng bộ thất bại, sẽ tự động đồng bộ lại sau 5 giây!'),
                backgroundColor: Colors.red,
                padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
              ),
            );
            await Future.delayed(const Duration(seconds: 5));
            await _actionWhenHaveConnect(context);
          }
        }
      }
    }
    catch(e){
      log("$e");
    }
  }

  Future<bool> asyncData(BuildContext context) async{
    try{
      return await Future.any([
        Future(() async {
          List<HistoryModel> lstHistory = await sqLiteHistory.getList();
          bool isUpdate = false;

          for (var history in lstHistory) {
            bool updateSuccess = await userApi.updateStatusUser(history.userId!, history.newStatus!);
            isUpdate = updateSuccess;
          }

          if (isUpdate || lstHistory.isEmpty) {
            bool fetchSuccess = await fetchData(context);
            return fetchSuccess;
          }
          return false;
        }),
        Future.delayed(const Duration(seconds: 60), () => false)
      ]);
    }
    catch(e){
      log("$e");
      return false;
    }
  }

}