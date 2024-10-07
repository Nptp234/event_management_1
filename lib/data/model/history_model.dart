import 'package:event_management_1/data/model/user_model.dart';

class HistoryModelProperty{
  String historyId="HistoryID", dateCreated="DateCreated", userId=UserModelProperty().userId, oldStatus='OldStatus', newStatus='NewStatus';
}

class HistoryModel{
  HistoryModelProperty property = HistoryModelProperty();
  String? historyId, dateCreated, userId, oldStatus, newStatus;
  HistoryModel({this.historyId, required this.dateCreated, required this.userId, required this.oldStatus, required this.newStatus});

  HistoryModel.fromJson(Map<dynamic, dynamic> e){
    historyId = e[property.historyId].toString();
    dateCreated = e[property.dateCreated];
    userId = e[property.userId];
    oldStatus = e[property.oldStatus];
    newStatus = e[property.newStatus];
  }
}