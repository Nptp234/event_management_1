import 'package:event_management_1/model/const.dart';

class UserModelProperty{
  String userId="userID", 
        eventId="eventID", 
        userCode="userCode", 
        fullname="fullName", 
        cccd="cccd", 
        phone="phone", 
        email="email", 
        status="isCheck",
        facility="facility",
        office="office", 
        desciption="desciption", 
        userUpdate="userUpdated",
        userCreate="userCreated",
        dateCreate="dateCreated",
        dateUpdate="dateUpdated";
}

class UserModel{
  String? userId, eventId, userCode, fullname, cccd, phone, email, status;
  String? facility, office, desciption, userUpdate, userCreate, dateCreate, dateUpdate;
  UserModelProperty userModelProperty = UserModelProperty();

  UserModel({
    required this.userId,
    required this.userCode,
    required this.fullname, 
    required this.cccd, 
    required this.phone,
    required this.email,
    required this.status,
    required this.eventId,
    this.facility, this.office, this.desciption, this.userUpdate, this.dateCreate, this.dateUpdate, this.userCreate
  });

  UserModel.fromJson(Map<dynamic, dynamic> e){
    if (e.containsKey("event") && e["event"].containsKey(userModelProperty.eventId)) {
      eventId = e["event"][userModelProperty.eventId].toString();
    } else {
      eventId = e[userModelProperty.eventId];
    }

    userId = e[userModelProperty.userId].toString();
    userCode = e[userModelProperty.userCode]??"";
    fullname = e[userModelProperty.fullname]??"";
    cccd = e[userModelProperty.cccd]??"";
    phone = e[userModelProperty.phone]??"";
    email = e[userModelProperty.email]??"";
    status = e[userModelProperty.status]==1?userState(1):userState(0);
    facility = e[userModelProperty.facility]??"";
    office = e[userModelProperty.office]??"";
    desciption = e[userModelProperty.desciption]??"";
    userCreate = e[userModelProperty.userCreate]??"";
    userUpdate = e[userModelProperty.userUpdate]??"";
    dateCreate = e[userModelProperty.dateCreate]??"";
    dateUpdate = e[userModelProperty.dateUpdate]??"";
  }
}