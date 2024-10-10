// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:event_management_1/controll/data/fetch_data.dart';
import 'package:event_management_1/model/bottom_menu.dart';
import 'package:event_management_1/model/const.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  void _showRedoApp(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot dismiss the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lấy dữ liệu gặp vấn đề!", style: TextStyle(fontWeight: FontWeight.bold),),
          content: const Text("Không thể lấy dữ liệu. Bạn có muốn chúng tôi khởi động lại app không?", style: TextStyle(fontWeight: FontWeight.bold),),
          actions: <Widget>[
            TextButton(
              child: Text("Đồng ý", style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),),
              onPressed: () async {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const WelcomeScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () async {
      bool fetchSuccess = await fetchData(context);
      
      if (fetchSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomMenu(),
          ),
        );
      } else {
        _showRedoApp(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _body(context))
    );
  }

  Widget _body(BuildContext context){
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoadingAnimationWidget.halfTriangleDot(
            color: mainColor, 
            size: 65
          ),
          const SizedBox(height: 20,),
          Text('Vui lòng chờ vài giây vì chúng tôi đang lấy dữ liệu cho bạn!', style: TextStyle(fontSize: 15, color: mainColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}