import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:event_management_1/model/search_bar.dart';
import 'package:event_management_1/model/user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListUserPage extends StatefulWidget{
  ListUserPage({super.key});

  final List<UserModel> lst = [
    UserModel(username: 'Phuoc1', phone: '0123456788', email: 'phuoc1@gmail.com', status: 'Checked'),
    UserModel(username: 'Phuoc2', phone: '0123456777', email: 'phuoc2@gmail.com', status: 'Checked'),
    UserModel(username: 'Phuoc3', phone: '0123456666', email: 'phuoc3@gmail.com', status: 'Checked'),
    UserModel(username: 'Phuoc4', phone: '0123455555', email: 'phuo4@gmail.com', status: 'Checked'),
    UserModel(username: 'Phuoc5', phone: '0123444444', email: 'phuoc5@gmail.com', status: 'UnCheck'),
    UserModel(username: 'Phuoc6', phone: '0123333333', email: 'phuoc6@gmail.com', status: 'Checked'),
    UserModel(username: 'Phuoc7', phone: '0122222222', email: 'phuoc7@gmail.com', status: 'UnCheck'),
  ];

  @override
  State<ListUserPage> createState() => _ListUserPage();
}

class _ListUserPage extends State<ListUserPage>{

  @override
  void initState() {
    final userProvider = Provider.of<ListUserProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userProvider.setList(widget.lst);
    });
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
      child: SafeArea(child: SearchBarModel())
    );
  }

  Widget _body(BuildContext context){
    return Container(
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
                  return UserItem(user: user, colorState: colorState(user.status));
                }
              );
            },
          )
        );
  }


}