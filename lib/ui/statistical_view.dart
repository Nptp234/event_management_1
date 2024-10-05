import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';

class StatisticalView extends StatefulWidget{
  const StatisticalView({super.key});

  @override
  State<StatisticalView> createState() => _StatisticalView();
}

class _StatisticalView extends State<StatisticalView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
    );
  }

}