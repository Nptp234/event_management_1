
import 'package:event_management_1/model/const.dart';
import 'package:event_management_1/ui/list_user.dart';
import 'package:event_management_1/ui/qr_view.dart';
import 'package:event_management_1/ui/statistical_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class BottomMenu extends StatefulWidget{
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenu();
}

class _BottomMenu extends State<BottomMenu> with TickerProviderStateMixin{
  
  MotionTabBarController? _motionTabBarController;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 3, 
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _motionTabBarController!.dispose();
    _pageController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _motionTabBarController!.index = index;
          });
        },
        children: [
          ListUserPage(),
          StatisticalView(),
          QRViewPage(),
        ],
      ),

      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        tabIconSize: 28.0,
        tabIconSelectedSize: 30.0,
        tabIconColor: Colors.grey,
        tabSelectedColor: mainColor,
        tabIconSelectedColor: Colors.white,
        tabSize: 50,
        tabBarHeight: 60,
        tabBarColor: Colors.white,
        textStyle: const TextStyle(color: Colors.transparent),

        initialSelectedTab: "List User", 
        labels: const ["List User", "Statistical", "QR Scan"],
        icons: const [Icons.list, Icons.bar_chart, Icons.qr_code],

        onTabItemSelected: (int value) {
            setState(() {
              _motionTabBarController!.index = value;
              _pageController.jumpToPage(value);
            });
          },
      ),
    );
  }

}