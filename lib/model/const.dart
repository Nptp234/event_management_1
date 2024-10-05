import 'package:flutter/material.dart';

double getMainHeight(BuildContext context)=>MediaQuery.of(context).size.height;

double getMainWidth(BuildContext context)=>MediaQuery.of(context).size.width;

Color mainColor = const Color(0xFF0060FF);

Color colorState(String state){
  switch(state){
    case "Checked": return Colors.green;
    case "UnCheck": return Colors.red;
    default: throw Error();
  }
}
