
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection() async{
  var connectResult = await (Connectivity().checkConnectivity());
  return connectResult.contains(ConnectivityResult.mobile) || connectResult.contains(ConnectivityResult.wifi);
}

