class EventModel{
  String? eventId, eventCode, eventName, userCreated, userUpdated, dateCreated, dateUpdated;
  EventModel({
    required this.eventId,
    required this.eventCode,
    required this.eventName,
    this.userCreated, this.userUpdated, this.dateCreated, this.dateUpdated
  });

  EventModel.fomrJson(Map<dynamic, dynamic> e){
    eventId = e["EventID"];
    eventCode = e["EventCode"];
    eventName = e["EventName"];
  }
}