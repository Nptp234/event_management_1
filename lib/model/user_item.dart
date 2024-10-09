
// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:event_management_1/controll/check_connection.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/local/history_data_local.dart';
import 'package:event_management_1/data/local/user_data_local.dart';
import 'package:event_management_1/data/model/history_model.dart';
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
  final SQLiteUser userSqlite = SQLiteUser();
  final SQLiteHistory historySqlite = SQLiteHistory();

  bool _isLoading = false; 

  HistoryModel _setHistory(UserModel user, String oldStatus){
    return HistoryModel(
      dateCreated: DateTime.now().toString(), 
      userId: user.userId, 
      oldStatus: oldStatus, 
      newStatus: user.status
    );
  }

  Future<bool> _checkStatus(BuildContext context) async{
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận", style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text("Bạn muốn thay đổi trạng thái tham gia của '${widget.user.fullname}'?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); 
              },
              child: const Text("Hủy", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: Text("Đồng ý", style: TextStyle(fontWeight: FontWeight.bold, color: mainColor),),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Future<void> _doUpdate(ListUserProvider value, BuildContext context) async{
    try{
      setState(() {
        _isLoading = true;
      });
      
      try {
        final updatedStatus = widget.user.status == userState(1) ? userState(2) : userState(1);
        widget.user.status = updatedStatus;

        bool isUpdateApi = await userApi.updateStatusUser(widget.user.userId!, widget.user.status!, context)
          .timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng thực hiện lại sau.");
        });
        
        

        if (isUpdateApi) {
          setState(() {
            iconCheck = updatedStatus == userState(1) ? check_box_outlined : square_outlined;
            widget.colorState = colorState(updatedStatus);
            widget.user.status = updatedStatus; 
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
    catch(e){
      log("$e");
    }
  }

  Future<void> _doUpdateLocal(ListUserProvider value, BuildContext context) async{
    try{
      setState(() {
        _isLoading = true;
      });
      
      try {
        final oldStatus = widget.user.status;
        final updatedStatus = widget.user.status == userState(1) ? userState(2) : userState(1);
        widget.user.status = updatedStatus;

        bool isUpdateLocal = await userSqlite.updateUser(widget.user)
          .timeout(const Duration(seconds: 35), onTimeout: () {
          throw TimeoutException("Thời gian chờ quá lâu. Vui lòng thực hiện lại sau.");
        });

        HistoryModel history = _setHistory(widget.user, oldStatus!);
        await historySqlite.addHistory(history);
        
        if (isUpdateLocal) {
          setState(() {
            iconCheck = updatedStatus == userState(1) ? check_box_outlined : square_outlined;
            widget.colorState = colorState(updatedStatus);
            widget.user.status = updatedStatus; 
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
    catch(e){
      log("$e");
    }
  }

  Future<void> handleUpdateStatus(ListUserProvider value, BuildContext context) async {
    bool canDo = await _checkStatus(context);
    bool isConnect = await checkInternetConnection();

    if(canDo){
      if(isConnect){
        await _doUpdate(value, context);
      }
      else{
        await _doUpdateLocal(value, context);
      }
    }
  }

  @override
  void initState() {
    iconCheck = widget.user.status == userState(1) ? check_box_outlined : square_outlined;
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
                SizedBox(
                  width: getMainWidth(context)/1.75,
                  child: Flexible(
                    child: Text(widget.user.fullname!, style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 3, textAlign: TextAlign.left, overflow: TextOverflow.ellipsis, softWrap: true,),
                  ),
                ),
                const SizedBox(height: 7,),
                // 
                Text("Email: ${widget.user.email}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 2, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                Text("SDT: ${widget.user.phone}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 1, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                Text("CCCD: ${widget.user.cccd}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 1, textAlign: TextAlign.left,),
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