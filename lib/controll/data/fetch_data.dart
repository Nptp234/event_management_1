// ignore_for_file: use_build_context_synchronously, unused_element

import 'dart:async';
import 'dart:developer';

import 'package:event_management_1/controll/check_connection.dart';
import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/event_api.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/local/event_data_local.dart';
import 'package:event_management_1/data/local/user_data_local.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final UserApi userApi = UserApi();
final EventApi eventApi = EventApi();
final SQLiteUser sqLiteUser = SQLiteUser();
final SQLiteEvent sqLiteEvent = SQLiteEvent();

  Future<bool> fetchDataOnline(BuildContext context) async {
    try {
      final responses = await Future.wait([
        userApi.getList().timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng chạy lại app.");
        }),
        eventApi.getList().timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng chạy lại app.");
        }),
      ]);

      if (responses.contains(null)) {
        return false; 
      }

      List<UserModel> lstUser = responses[0] as List<UserModel>;
      List<EventModel> lstEvent = responses[1] as List<EventModel>;

      if (lstUser.isNotEmpty && lstEvent.isNotEmpty) {
        final userProvider = Provider.of<ListUserProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userProvider.setList(lstUser);
          userProvider.filterListEventID(userProvider.eventIdFilter??lstEvent[0].eventId!);
          userProvider.setEventName(userProvider.eventName??lstEvent[0].eventName!);
        });
        await sqLiteUser.setList(lstUser);

        final eventProvider = Provider.of<ListEventProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          eventProvider.setList(lstEvent);
        });
        await sqLiteEvent.setList(lstEvent);

        return true; 
      }

      return false; 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false; 
    }
  }

  Future<bool> fetchDataLocal(BuildContext context) async{
    try{
      final responses = await Future.wait([
        sqLiteUser.getList().timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng chạy lại app.");
        }),
        sqLiteEvent.getList().timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng chạy lại app.");
        })
      ]);

      if (responses.contains(null)) {
        return false; 
      }

      List<UserModel> lstUser = responses[0] as List<UserModel>;
      List<EventModel> lstEvent = responses[1] as List<EventModel>;


      if (lstUser.isNotEmpty && lstEvent.isNotEmpty) {
        final userProvider = Provider.of<ListUserProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userProvider.setList(lstUser);
          userProvider.filterListEventID(userProvider.eventIdFilter??lstEvent[0].eventId!);
          userProvider.setEventName(userProvider.eventName??lstEvent[0].eventName!);
        });

        final eventProvider = Provider.of<ListEventProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          eventProvider.setList(lstEvent);
        });

        return true; 
      }

      return false; 

    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false; 
    }
  }

  Future<bool> fetchData(BuildContext context) async{
    try{
      bool isCheckConnect = await checkInternetConnection();
      if(isCheckConnect){
        bool isFetchOnline = await fetchDataOnline(context);
        return isFetchOnline;
      }else{
        bool isFetchLocal = await fetchDataLocal(context);
        return isFetchLocal;
      }
    }
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã có lỗi xảy ra: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return false; 
    }
  } 

  Timer? _timer;

  void asyncDataOnlineOnly(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 120), (Timer timer) async{
      bool isConnect = await checkInternetConnection();
      if(isConnect){
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