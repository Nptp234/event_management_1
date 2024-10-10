import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/model/event_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventFilterBar extends StatefulWidget{
  EventFilterBar({super.key});
  String? valueDropdown;

  @override
  State<EventFilterBar> createState() => _EventFilterBar();
}

class _EventFilterBar extends State<EventFilterBar>{

  String? dropdownValue;
  final String? firstValue = "Chọn sự kiện";

  void _updateDropdownValue(String value){
    dropdownValue = value;
  }

  @override
  void initState() {
    dropdownValue = widget.valueDropdown;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListUserProvider>(
      builder: (context, value, child) {
        return Container(
          width: getMainWidth(context),
          height: 100,
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 0, child: Text("Chọn sự kiện: ", style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: _dropdownButton(value),
                )
              )
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
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(20),
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
                  child: Flexible(child: Text(event.eventName!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), softWrap: true, overflow: TextOverflow.ellipsis, maxLines: 3,))
                );
              }
            ).toList(), 
          ),
        );
      },
    );
  }

}