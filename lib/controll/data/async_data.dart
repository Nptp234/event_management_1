// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:async';
import 'dart:developer';

import 'package:event_management_1/controll/check_connection.dart';
import 'package:event_management_1/controll/data/fetch_data.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/local/event_data_local.dart';
import 'package:event_management_1/data/local/history_data_local.dart';
import 'package:event_management_1/data/local/user_data_local.dart';
import 'package:event_management_1/data/model/history_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';


  final SQLiteUser sqLiteUser = SQLiteUser();
  final SQLiteEvent sqLiteEvent = SQLiteEvent();
  final SQLiteHistory sqLiteHistory = SQLiteHistory();
  final UserApi userApi = UserApi();
  Timer? _timer;
  bool isAsyncDataRunning = false;

  Future<bool> asyncData(BuildContext context) async{
    try{
      isAsyncDataRunning = true;
      return await Future.any([
        Future(() async {
          List<HistoryModel> lstHistory = await sqLiteHistory.getList();
          bool isUpdate = false;

          for (var history in lstHistory) {
            bool updateSuccess = await userApi.updateStatusUser(history.userId!, history.newStatus!, context);
            isUpdate = updateSuccess;
            await Future.delayed(const Duration(seconds: 3));
          }

          if (isUpdate || lstHistory.isEmpty) {
            bool fetchSuccess = await fetchData(context);
            return fetchSuccess;
          }
          return false;
        }),
      ]);
    }
    catch(e){
      log("$e");
      return false;
    } finally {
      isAsyncDataRunning = false;
    }
  }

  void asyncDataOnlineOnly(BuildContext context) {
    _timer = Timer.periodic(const Duration(minutes: 2), (Timer timer) async{
      bool isConnect = await checkInternetConnection();
      if(isConnect && !isAsyncDataRunning){
        fetchDataOnline(context).then((isSuccess) {
          if (isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Dữ liệu đã đồng bộ thành công'),
                backgroundColor: mainColor,
                padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Dữ liệu đã đồng bộ thất bại'),
                backgroundColor: Colors.red,
                padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
              ),
            );
          }
        }).catchError((error) {
          log('Đã xảy ra lỗi: $error');
        });
      }
    });
  }