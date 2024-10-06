import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/event_api.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final UserApi userApi = UserApi();
final EventApi eventApi = EventApi();

Future<void> fetchData(BuildContext context) async{
    try{
      List<UserModel> lstUser = await userApi.getList();
      List<EventModel> lstEvent = await eventApi.getList();

      if(lstUser.isNotEmpty && lstEvent.isNotEmpty){
        final userProvider = Provider.of<ListUserProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          userProvider.setList(lstUser);
          userProvider.filterListEventID(lstEvent[0].eventId!);
          userProvider.setEventName(lstEvent[0].eventName!);
        });

        // EventFilterBar().valueDropdown = lstEvent[0].eventName;
        final provider = Provider.of<ListEventProvider>(context, listen: false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          provider.setList(lstEvent);
        });
      }
    }
    catch(e){
      rethrow;
    }
  }