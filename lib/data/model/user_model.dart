class UserModel{
  String? userId, eventId, userCode, fullname, cccd, phone, email, status;
  String? facility, office, desciption, userUpdate;
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
    userId = e["UserID"];
    eventId = e["EventID"];
    userCode = e["UserCode"];
    fullname = e["FullName"];
    cccd = e["CCCD"];
    phone = e["Phone"];
    email = e["Email"];
    status = e["isCheck"];
  }
}