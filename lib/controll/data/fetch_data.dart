import 'dart:async';

import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/event_api.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

final UserApi userApi = UserApi();
final EventApi eventApi = EventApi();

// Future<void> fetchData(BuildContext context) async{
//     try{
//       List<UserModel> lstUser = await userApi.getList();
//       List<EventModel> lstEvent = await eventApi.getList();

//       if(lstUser.isNotEmpty && lstEvent.isNotEmpty){
//         final userProvider = Provider.of<ListUserProvider>(context, listen: false);
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           userProvider.setList(lstUser);
//           userProvider.filterListEventID(lstEvent[0].eventId!);
//           userProvider.setEventName(lstEvent[0].eventName!);
//         });

//         // EventFilterBar().valueDropdown = lstEvent[0].eventName;
//         final provider = Provider.of<ListEventProvider>(context, listen: false);
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           provider.setList(lstEvent);
//         });
//       }
//     }
//     catch(e){
//       rethrow;
//     }
//   }

  Future<bool> fetchData(BuildContext context) async {
    try {
      final responses = await Future.wait([
        userApi.getList().timeout(const Duration(seconds: 20), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng chạy lại app.");
        }),
        eventApi.getList().timeout(const Duration(seconds: 20), onTimeout: () {
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

        final eventProvider = Provider.of<ListEventProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          eventProvider.setList(lstEvent);
        });

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