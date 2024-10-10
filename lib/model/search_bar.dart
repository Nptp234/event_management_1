import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarModel extends StatefulWidget{
  const SearchBarModel({super.key});

  @override
  State<SearchBarModel> createState() => _SearchBarModel();
}

class _SearchBarModel extends State<SearchBarModel>{

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ListUserProvider>(
      builder: (context, provider, child) {
        return Container(
          width: getMainWidth(context),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 5),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Tìm kiếm với tên, email hoặc số điện thoại",
              hintStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
              prefixIcon: const Icon(Icons.search, size: 30,),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(width: 3, color: Colors.grey)),
              errorBorder: null,
              enabledBorder: null,
              focusedBorder: null,
              disabledBorder: null,
              focusedErrorBorder: null
            ),
            onChanged: (value) {
              provider.filterListSearch(value);
            },

          )
        );
      },
    );
  }

}

