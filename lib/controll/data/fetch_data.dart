import 'dart:async';

import 'package:event_management_1/controll/check_connection.dart';
import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/event_api.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/local/event_data_local.dart';
import 'package:event_management_1/data/local/user_data_local.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

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
          userProvider.filterListEventID(lstEvent[0].eventId!);
          userProvider.setEventName(lstEvent[0].eventName!);
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
          userProvider.filterListEventID(lstEvent[0].eventId!);
          userProvider.setEventName(lstEvent[0].eventName!);
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