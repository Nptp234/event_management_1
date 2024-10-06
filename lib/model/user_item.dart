
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/data/model/user_model.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserItem extends StatefulWidget{

  UserItem({super.key, required this.user, required this.colorState});
  UserModel user;
  Color colorState;

  @override
  State<UserItem> createState() => _UserItem();
}

class _UserItem extends State<UserItem>{

  IconData? iconCheck;
  IconData square_outlined = Icons.square_outlined;
  IconData check_box_outlined = Icons.check_box_outlined;

  @override
  void initState() {
    if(widget.user.status=="Checked"){
      iconCheck = check_box_outlined;
    }else{iconCheck = square_outlined;}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      // height: 70,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[100]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 
                Text(widget.user.username, style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                Text("Email: ${widget.user.email}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 2, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                Text("SDT: ${widget.user.phone}", style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal), maxLines: 1, textAlign: TextAlign.left,),
                const SizedBox(height: 7,),
                // 
                const SizedBox(height: 10,),
                Text(widget.user.status, style: TextStyle(fontSize: 15, color: widget.colorState, fontWeight: FontWeight.bold), maxLines: 1, textAlign: TextAlign.left,),
              ],
            ),
          ),
          Consumer<ListUserProvider>(
            builder: (context, value, child) {
              return IconButton(
                onPressed: (){
                  if(iconCheck==square_outlined){
                    setState(() {
                      iconCheck=check_box_outlined;
                      widget.user.status="Checked";
                      widget.colorState = colorState("Checked");
                    });
                  }else{
                    setState(() {
                      iconCheck=square_outlined;
                      widget.user.status="UnCheck";
                      widget.colorState = colorState("UnCheck");
                    });
                  }
                  value.updateUser(widget.user);
                }, 
                icon: Icon(iconCheck, color: mainColor, size: 25,)
              );
            },
          ),
        ],
      )
    );
  }

}