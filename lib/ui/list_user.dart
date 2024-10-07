import 'dart:async';

import 'package:event_management_1/controll/data/fetch_data.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/model/const.dart';
import 'package:event_management_1/model/event_filter_bar.dart';
import 'package:event_management_1/model/search_bar.dart';
import 'package:event_management_1/model/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListUserPage extends StatefulWidget{
  ListUserPage({super.key});

  // final List<UserModel> lst = [
  //   UserModel(fullname: 'Phuoc1', phone: '0123456788', email: 'phuoc1@gmail.com', status: 'Checked', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '1'),
  //   UserModel(fullname: 'Phuoc2', phone: '0123456777', email: 'phuoc2@gmail.com', status: 'Checked', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '2'),
  //   UserModel(fullname: 'Phuoc3', phone: '0123456666', email: 'phuoc3@gmail.com', status: 'Checked', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '3'),
  //   UserModel(fullname: 'Phuoc4', phone: '0123455555', email: 'phuo4@gmail.com', status: 'Checked', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '1'),
  //   UserModel(fullname: 'Phuoc5', phone: '0123444444', email: 'phuoc5@gmail.com', status: 'UnCheck', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '3'),
  //   UserModel(fullname: 'Phuoc6', phone: '0123333333', email: 'phuoc6@gmail.com', status: 'Checked', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '1'),
  //   UserModel(fullname: 'Phuoc7', phone: '0122222222', email: 'phuoc7@gmail.com', status: 'UnCheck', cccd: '012345678912', userId: '1', userCode: '0123', eventId: '2'),
  // ];

  @override
  State<ListUserPage> createState() => _ListUserPage();
}

class _ListUserPage extends State<ListUserPage>{

  Future<void> _onRefresh(BuildContext context) async{
    try{
      bool fetchSuccess = await fetchData(context);
      if (!fetchSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể tải dữ liệu. Vui lòng thử lại.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    catch(e){
      throw Exception(e);
    }
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _header(context),
      body: _body(context),
    );
  }

  PreferredSize _header(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(getMainHeight(context)/6), 
      child: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchBarModel(),
          const SizedBox(height: 15,),
          EventFilterBar()
        ],
      ))
    );
  }

  Widget _body(BuildContext context){
    return RefreshIndicator(
      onRefresh: (){
        return _onRefresh(context);
      },
      child: Container(
          width: getMainWidth(context),
          height: getMainHeight(context),
          padding: const EdgeInsets.all(10),
          child: Consumer<ListUserProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.lstUser.length,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index){
                  final user = value.lstUser[index];
                  return UserItem(user: user, colorState: colorState(user.status!));
                }
              );
            },
          )
        ), 
    );
  }


}