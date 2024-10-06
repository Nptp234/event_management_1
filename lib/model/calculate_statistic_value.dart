import 'package:event_management_1/data/model/user_model.dart';

Map<String, double> _values = {
  "Checked": 0,
  "UnCheck": 0,
};

void setValueList(List<UserModel> lst){
  _values.updateAll((key, value) => 0);
  for(var user in lst){
    String state = user.status!;
    switch (state) {
      case "Checked":
        _values["Checked"] = (_values["Checked"] ?? 0) + 1;
        break;
      case "UnCheck":
        _values["UnCheck"] = (_values["UnCheck"] ?? 0) + 1;
        break;
    }
  }
}

double calculatePercentage(String state) {
  double total = _values.values.reduce((a, b) => a + b);
  if (total == 0) return 0; 
  double percent = ((_values[state] ?? 0) / total) * 100;
  return double.parse(percent.toStringAsFixed(2));
}