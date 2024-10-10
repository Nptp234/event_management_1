import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';

Map<String, double> _values = {
  userState(1): 0,
  userState(0): 0,
};

void setValueList(List<UserModel> lst){
  _values.updateAll((key, value) => 0);
  String check = userState(1);
  for(var user in lst){
    String state = user.status!;
    // switch (state) {
    //   case check:
    //     _values["Checked"] = (_values["Checked"] ?? 0) + 1;
    //     break;
    //   case "UnCheck":
    //     _values["UnCheck"] = (_values["UnCheck"] ?? 0) + 1;
    //     break;
    // }
    if(state==userState(1)){
      _values[userState(1)] = (_values[userState(1)] ?? 0) + 1;
    }else{_values[userState(0)] = (_values[userState(0)] ?? 0) + 1;}
  }
}

double calculatePercentage(String state) {
  double total = _values.values.reduce((a, b) => a + b);
  if (total == 0) return 0; 
  double percent = ((_values[state] ?? 0) / total) * 100;
  return double.parse(percent.toStringAsFixed(2));
}