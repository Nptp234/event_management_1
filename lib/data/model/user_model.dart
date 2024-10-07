class UserModelProperty{
  String userId="UserID", 
        eventId="EventID", 
        userCode="UserCode", 
        fullname="FullName", 
        cccd="CCCD", 
        phone="Phone", 
        email="Email", 
        status="isCheck";
}

class UserModel{
  String? userId, eventId, userCode, fullname, cccd, phone, email, status;
  String? facility, office, desciption, userUpdate;
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
    this.facility, this.office, this.desciption, this.userUpdate
  });

  UserModel.fromJson(Map<dynamic, dynamic> e){
    userId = e[userModelProperty.userId].toString();
    eventId = e[userModelProperty.eventId];
    userCode = e[userModelProperty.userCode];
    fullname = e[userModelProperty.fullname];
    cccd = e[userModelProperty.cccd];
    phone = e[userModelProperty.phone];
    email = e[userModelProperty.email];
    status = e[userModelProperty.status];
  }
}