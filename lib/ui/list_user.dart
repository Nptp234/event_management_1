// ignore_for_file: use_build_context_synchronously

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
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPage();
}

class _ListUserPage extends State<ListUserPage>{

  Future<void> _onRefresh(BuildContext context) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang tải dữ liệu...'),
        backgroundColor: Colors.blue,
        padding: EdgeInsets.only(bottom: 50),
      ),
    );

    bool fetchSuccess = await fetchData(context);
    if (!fetchSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể tải dữ liệu lúc này. Vui lòng thử lại sau vài giây.'),
          backgroundColor: Colors.red,
        padding: EdgeInsets.only(bottom: 50),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Có lỗi xảy ra: $e'),
        backgroundColor: Colors.red,
        padding: const EdgeInsets.only(bottom: 50),
      ),
    );
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
      preferredSize: Size.fromHeight(getMainHeight(context)/4.5), 
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBarModel(),
            EventFilterBar()
          ],
        )
      )
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