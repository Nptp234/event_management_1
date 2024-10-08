import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventFilterBar extends StatefulWidget{
  EventFilterBar({super.key});

  // List<EventModel> lstEvent = [
  //   EventModel(eventId: '1', eventCode: '123', eventName: 'Sự kiện đầu'),
  //   EventModel(eventId: '2', eventCode: '122', eventName: 'Sự kiện sau'),
  //   EventModel(eventId: '3', eventCode: '111', eventName: 'Sự kiện cuối'),
  // ];
  String? valueDropdown;

  @override
  State<EventFilterBar> createState() => _EventFilterBar();
}

class _EventFilterBar extends State<EventFilterBar>{

  String? dropdownValue;

  void _updateDropdownValue(String value){
    dropdownValue = value;
  }

  @override
  void initState() {
    dropdownValue=widget.valueDropdown;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListUserProvider>(
      builder: (context, value, child) {
        return Container(
          width: getMainWidth(context),
          height: 50,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 0, child: Text("Chọn sự kiện: ", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),),
              Expanded(flex: 1, child: _dropdownButton(value))
            ],
          ),
        );
      },
    );
  }

  Widget _dropdownButton(ListUserProvider provider){
    return Consumer<ListEventProvider>(
      builder: (context, value, child) {
        return Flexible(
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward_rounded, size: 25, color: Colors.grey,),
            elevation: 16,
            isExpanded: true,
            style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
            onChanged: (String? currentValue){
              setState(() {
                dropdownValue = currentValue!;
                widget.valueDropdown = dropdownValue;
                _updateDropdownValue(currentValue);
                EventModel event = value.lstEvent.firstWhere((event) => event.eventName == dropdownValue);
                provider.filterListEventID(event.eventId!);
                provider.setEventName(event.eventName!);
              });
            },
            items: value.lstEvent.map<DropdownMenuItem<String>>(
              (EventModel event){
                return DropdownMenuItem<String>(
                  value: event.eventName,
                  child: Flexible(child: Text(event.eventName!, softWrap: true, overflow: TextOverflow.ellipsis,))
                );
              }
            ).toList(), 
          ),
        );
      },
    );
  }

}