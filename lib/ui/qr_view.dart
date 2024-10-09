// ignore_for_file: use_build_context_synchronously

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
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewPage extends StatefulWidget{
  QRViewPage({super.key});
  bool isProcessing=false;

  @override
  State<QRViewPage> createState() => _QRView();
}

class _QRView extends State<QRViewPage>{

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final SQLiteHistory sqLiteHistory = SQLiteHistory();
  final SQLiteUser sqLiteUser = SQLiteUser();
  QRViewController? controller;
  Barcode? result;
  List<UserModel?> lstUser = [];
  UserApi userApi = UserApi();
  bool isUpdating = false;

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }
  
  HistoryModel _setHistory(UserModel user, String oldStatus){
    return HistoryModel(
      dateCreated: DateTime.now().toString(), 
      userId: user.userId, 
      oldStatus: oldStatus, 
      newStatus: user.status
    );
  }

  Future<void> showDialogUpdate(UserModel user, BuildContext contextt) async{
    try{
      showDialog(
            context: contextt,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text("Thông tin người dùng", style: TextStyle(fontWeight: FontWeight.bold),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Họ tên: ${user.fullname}', style: const TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 7),
                        Text('Số điện thoại: ${user.phone}', style: const TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            isUpdating = true;
                          });
                          final oldStatus = user.status;
                          user.status = userState(1);
                          await userApi.updateStatusUser(user.userId!, user.status!,context);
                          bool checkConnect = await checkInternetConnection();
                          if(checkConnect){
                            await userApi.updateStatusUser(user.userId!, user.status!,context);
                          }
                          else{
                            bool isUpdateLocal = await sqLiteUser.updateUser(user);
                            HistoryModel history = _setHistory(user, oldStatus!);
                            await sqLiteHistory.addHistory(history);
                            
                            if (isUpdateLocal) {
                              final userProvider = Provider.of<ListUserProvider>(context, listen: false);
                              userProvider.updateUser(user); 
                            } else {
                              throw Exception('Hiện tại không thể cập nhật thông tin.');
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã xác nhận cho ${user.fullname}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          isUpdating = false;
                          widget.isProcessing = false;
                          controller?.resumeCamera();
                          Navigator.of(context).pop();
                        },
                        child: isUpdating
                            ? CircularProgressIndicator(
                                color: mainColor, 
                                strokeWidth: 2,
                              )
                            : const Text(
                                "Xác nhận",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  );
                },
              );
            },
          ).then(
            (val){
              controller?.resumeCamera();
            }
          );
    }
    catch(e){
      log("$e");
    }
  }
  

  Future<void> _validateQRCode(String? qrCode, BuildContext context) async {
    if (widget.isProcessing==true) return;

    widget.isProcessing = true;
    controller?.pauseCamera();

    await Future.delayed(const Duration(seconds: 1));

    if (qrCode == null || qrCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã QR không hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      controller?.resumeCamera();
    } 
    else {
      final users = lstUser.where((user) => user!.fullname!.trim().contains(qrCode.trim())).toList();

      if (users.isNotEmpty) {
        UserModel user = users.first!;
        if(!isUpdating){
          await showDialogUpdate(user, context);
        }
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mã QR không tồn tại!'),
            backgroundColor: Colors.red,
          ),
        );
        controller?.resumeCamera();
      }
    }
  }

  @override
  void initState() {
    _requestCameraPermission();
    final userProvider = Provider.of<ListUserProvider>(context, listen: false);
    lstUser = userProvider.lstUser;
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue, 
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 350,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      log("${scanData.code}");
      if (!widget.isProcessing) {
        _validateQRCode(scanData.code, context);
      }
    });
  }
  // _Uint8ArrayView ([65, 116, 142, 27, 185, 50, 4, 230, 126, 27, 184, 214, 50, 12, 73, 12, 72, 54, 230, 114, 4, 182, 134, 246, 16, 236, 17, 236, 17, 236, 17, 236, 17, 236])
  // _Uint8ArrayView ([65, 116, 142, 27, 185, 50, 4, 230, 126, 27, 184, 214, 50, 12, 73, 12, 72, 54, 230, 114, 4, 182, 134, 246, 16, 236, 17, 236, 17, 236, 17, 236, 17, 236])
  // _Uint8ArrayView ([65, 116, 142, 27, 185, 50, 4, 230, 126, 27, 184, 214, 50, 12, 73, 12, 72, 54, 230, 114, 4, 182, 134, 246, 16, 236, 17, 236, 17, 236, 17, 236, 17, 236])
}