import 'package:event_management_1/controll/state/list_event_provider.dart';
import 'package:event_management_1/controll/state/list_user_provide.dart';
import 'package:event_management_1/controll/state/statistic_provider.dart';
import 'package:event_management_1/ui/wellcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/assets/.env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ListUserProvider()),
        ChangeNotifierProvider(create: (context)=>StatisticProvider()),
        ChangeNotifierProvider(create: (context)=>ListEventProvider()),
      ],
      child: const MaterialApp(
        home: WelcomeScreen()
      ),
    );
  }
}
