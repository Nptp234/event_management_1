class EventModelProperty{
  String? eventId="eventID", eventCode="eventCode", eventName="eventName";
}

class EventModel{
  String? eventId, eventCode, eventName, userCreated, userUpdated, dateCreated, dateUpdated;
  EventModelProperty property = EventModelProperty();

  EventModel({
    required this.eventId,
    required this.eventCode,
    required this.eventName,
    this.userCreated, this.userUpdated, this.dateCreated, this.dateUpdated
  });

  EventModel.fromJson(Map<dynamic, dynamic> e){
    eventId = e[property.eventId].toString();
    eventCode = e[property.eventCode];
    eventName = e[property.eventName];
  }
}