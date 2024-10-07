
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

Future<bool> checkInternetConnection() async{
  var connectResult = await (Connectivity().checkConnectivity());
  return connectResult.contains(ConnectivityResult.mobile) || connectResult.contains(ConnectivityResult.wifi);
}


class ConnectivityService {
  Stream<List<ConnectivityResult>> get onConnectivityChanged => (Connectivity().onConnectivityChanged);

  void monitorConnection(BuildContext context) {
    onConnectivityChanged.listen(
      (result) async{
        bool isConnect = await checkInternetConnection();
        if(isConnect){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã có mạng trở lại, quá trình đồng bộ sẽ tự động bắt đầu!'),
              backgroundColor: Colors.red,
              padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
            ),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Mất kết nối, sẽ tự động chuyển sang sử dụng lưu trữ cục bộ!'),
              backgroundColor: Colors.red,
              padding: EdgeInsets.only(bottom: 30, left: 10, right: 10),
            ),
          );
        }
      }
    );
  }
}