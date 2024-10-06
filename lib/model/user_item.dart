
import 'dart:developer';

import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatefulWidget{

  UserItem({super.key, required this.user, required this.colorState});
  UserModel user;
  Color colorState;

  @override
  State<UserItem> createState() => _UserItem();
}

class _UserItem extends State<UserItem>{

  IconData? iconCheck;
  IconData square_outlined = Icons.square_outlined;
  IconData check_box_outlined = Icons.check_box_outlined;

  final UserApi userApi = UserApi();

  bool _isLoading = false; 

  Future<void> handleUpdateStatus(ListUserProvider value, BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      widget.user.status = widget.user.status == userState(1) ? userState(2) : userState(1);
      bool isUpdateApi = await userApi.updateStatusUser(widget.user);

      if (isUpdateApi) {
        setState(() {
          if (iconCheck == square_outlined) {
            iconCheck = check_box_outlined;
            widget.user.status = userState(1); //Checked
            widget.colorState = colorState(userState(1));
          } else {
            iconCheck = square_outlined;
            widget.user.status = userState(2); //UnCheck
            widget.colorState = colorState(userState(2));
          }
        });
        value.updateUser(widget.user); 
      } else {
        throw Exception('Hiện tại không thể cập nhật thông tin.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi xảy ra khi cố gắng cập nhật người dùng: $e'),
          backgroundColor: Colors.red,
        ),
      );
      log("$e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      // height: 70,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[100]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 
                Text(widget.user.fullname!, style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                Text("Email: ${widget.user.email}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 2, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                Text("SDT: ${widget.user.phone}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 1, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                const SizedBox(height: 10,),
                Text(widget.user.status!, style: TextStyle(fontSize: 15, color: widget.colorState, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.left,),
              ],
            ),
          ),
          Consumer<ListUserProvider>(
            builder: (context, value, child) {
              iconCheck = widget.user.status == userState(1) ? check_box_outlined : square_outlined;
              return IconButton(
                onPressed: _isLoading ? null: () async {
                  await handleUpdateStatus(value, context);
                },
                icon: _isLoading
                  ? CircularProgressIndicator(color: mainColor, strokeWidth: 2,)
                  : Icon(iconCheck, color: mainColor, size: 25),
              );
            },
          ),
        ],
      )
    );
  }

}