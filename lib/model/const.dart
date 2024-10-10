import 'package:flutter/material.dart';

double getMainHeight(BuildContext context)=>MediaQuery.of(context).size.height;

double getMainWidth(BuildContext context)=>MediaQuery.of(context).size.width;

Color mainColor = const Color(0xFF0060FF);

Color colorState(String state){
  switch(state){
    case "Đã duyệt": return Colors.green;
    case "Chưa duyệt": return Colors.red;
    default: throw Error();
  }
}

String userState(int i){
  switch (i){
    case 1: return 'Đã duyệt';
    default: return 'Chưa duyệt';
  }
}
