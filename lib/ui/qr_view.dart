// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/api/user_api.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewPage extends StatefulWidget{
  const QRViewPage({super.key});

  @override
  State<QRViewPage> createState() => _QRView();
}

class _QRView extends State<QRViewPage>{

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  List<UserModel?> lstUser = [];
  bool _isProcessing = false;
  UserApi userApi = UserApi();
  bool isUpdating = false;

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  // Future<void> _validateQRCode(String? qrCode, BuildContext context) async {
  //   if (_isProcessing) return; 

  //   _isProcessing = true;
  //   controller?.pauseCamera();

  //   await Future.delayed(const Duration(seconds: 1)); 

  //   if (qrCode == null || qrCode.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('QR code is empty or invalid'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } else if (validQRCodes.contains(qrCode)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('QR code is valid'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Invalid QR code'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }

  //   _isProcessing = false;
  //   controller?.resumeCamera(); 
  // }

  // Future<void> _validateQRCode(String? qrCode, BuildContext context) async {
  //   if (_isProcessing) return; // Tránh lặp lại nếu đang xử lý

  //   _isProcessing = true;
  //   controller?.pauseCamera(); // Tạm dừng camera khi đang xử lý

  //   await Future.delayed(const Duration(seconds: 1)); // Đợi 1 giây trước khi kiểm tra

  //   if (qrCode == null || qrCode.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('QR code is empty or invalid'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } else {
  //     final users = lstUser.where((user) => user!.fullname == qrCode).toList();

  //     if (users.isNotEmpty) {
  //       UserModel user = users.first!;
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text("Thông tin người dùng"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text('Họ tên: ${user.fullname}'),
  //                 const SizedBox(height: 10),
  //                 Text('Số điện thoại: ${user.phone}'),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () async{
  //                   // Cập nhật isCheck thành true
  //                   setState(() {
  //                     isUpdating=true;
  //                   });
  //                   user.status = userState(1);
  //                   await userApi.updateStatusUser(user.userId!, user.status!);
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     SnackBar(
  //                       content: Text('Đã xác nhận cho ${user.fullname}'),
  //                       backgroundColor: Colors.green,
  //                     ),
  //                   );
  //                   Navigator.of(context).pop(); 
  //                 },
  //                 child: isUpdating?CircularProgressIndicator(color: mainColor, strokeWidth: 2,):const Text("Xác nhận", style: TextStyle(fontWeight: FontWeight.bold),),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Mã QR không tồn tại!'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   }

  //   _isProcessing = false;
  //   controller?.resumeCamera();
  // }

  Future<void> _validateQRCode(String? qrCode, BuildContext context) async {
  if (_isProcessing) return;

  _isProcessing = true;
  controller?.pauseCamera();

  await Future.delayed(const Duration(seconds: 1));

  if (qrCode == null || qrCode.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR code is empty or invalid'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    final users = lstUser.where((user) => user!.fullname!.trim() == qrCode.trim()).toList();

    if (users.isNotEmpty) {
      UserModel user = users.first!;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Thông tin người dùng"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Họ tên: ${user.fullname}'),
                    const SizedBox(height: 10),
                    Text('Số điện thoại: ${user.phone}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isUpdating = true;
                      });

                      user.status = userState(1);
                      await userApi.updateStatusUser(user.userId!, user.status!);

                      setState(() {
                        isUpdating = false;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã xác nhận cho ${user.fullname}'),
                          backgroundColor: Colors.green,
                        ),
                      );

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
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã QR không tồn tại!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  _isProcessing = false;
  controller?.resumeCamera();
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
      if (!_isProcessing) {
        _validateQRCode(scanData.code, context);
      }
    });
  }
  // _Uint8ArrayView ([65, 116, 142, 27, 185, 50, 4, 230, 126, 27, 184, 214, 50, 12, 73, 12, 72, 54, 230, 114, 4, 182, 134, 246, 16, 236, 17, 236, 17, 236, 17, 236, 17, 236])
  // _Uint8ArrayView ([65, 116, 142, 27, 185, 50, 4, 230, 126, 27, 184, 214, 50, 12, 73, 12, 72, 54, 230, 114, 4, 182, 134, 246, 16, 236, 17, 236, 17, 236, 17, 236, 17, 236])
  // _Uint8ArrayView ([65, 116, 142, 27, 185, 50, 4, 230, 126, 27, 184, 214, 50, 12, 73, 12, 72, 54, 230, 114, 4, 182, 134, 246, 16, 236, 17, 236, 17, 236, 17, 236, 17, 236])
}