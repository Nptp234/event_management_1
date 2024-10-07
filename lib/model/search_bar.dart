import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarModel extends StatefulWidget{
  SearchBarModel({super.key});

  @override
  State<SearchBarModel> createState() => _SearchBarModel();
}

class _SearchBarModel extends State<SearchBarModel>{

  @override
  Widget build(BuildContext context) {
    return Consumer<ListUserProvider>(
      builder: (context, provider, child) {
        return Container(
          width: getMainWidth(context),
          margin: const EdgeInsets.only(top: 10),
          child: SearchAnchor(
            builder: (context, searchController){
              return SearchBar(
                controller: searchController,
                padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(10)),
                backgroundColor: const WidgetStatePropertyAll<Color>(Colors.white),
                onChanged: (value){
                  provider.filterListSearch(value);
                },
                leading: const Icon(Icons.search),

              );
            }, 
            suggestionsBuilder: (context, controller){
              return List<ListTile>.generate(
                0, (int index){
                  return ListTile(
                    title: Text(""),
                    onTap: () {},
                  );
                }
              );
            }
          ),
        );
      },
    );
  }

}

