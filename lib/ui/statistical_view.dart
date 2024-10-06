// ignore_for_file: prefer_const_constructors

import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/model/const.dart';
import 'package:event_management_1/model/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticalView extends StatefulWidget{
  const StatisticalView({super.key});

  @override
  State<StatisticalView> createState() => _StatisticalView();
}

class _StatisticalView extends State<StatisticalView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context){
    return Consumer<ListUserProvider>(
      builder: (context, value, child) {
        int total = value.lstUser.length;
        int totalScanned = value.lstUser.where((user) => user.status == "Checked").length;
        
        return Container(
          width: getMainWidth(context),
          height: getMainHeight(context),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: getMainWidth(context),
                child: Text("Sơ đồ thống kê", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),)
              ), const SizedBox(height: 20,),
              SizedBox(
                width: getMainWidth(context),
                child: PieChartView(lstuser: value.lstUser,)
              ),
              SizedBox(
                width: getMainWidth(context),
                child: Text("Chi tiết thống kê", style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),)
              ),const SizedBox(height: 10,),
              SizedBox(
                width: getMainWidth(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tổng số người tham gia: $total", style: TextStyle(fontSize: 20, color: Colors.black),),
                    Text("Tổng số người đã quét mã: $totalScanned", style: TextStyle(fontSize: 20, color: Colors.black),),
                  ],
                )
              ),
            ],
          ),
        );
      },
    );
  }

}