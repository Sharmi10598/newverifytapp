import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Constant/AllRoutes.dart';
import 'package:verifytapp/Controllers/AuditController/AuditControllers.dart';
import 'package:verifytapp/Controllers/DashBoardController/DashBoradControllers.dart';
import 'package:verifytapp/Controllers/LoginController/LoginControllers.dart';
import 'package:verifytapp/DBHelper/DBHelpers.dart';
import 'package:verifytapp/Themes/theme_manager.dart';
import 'Controllers/ConfigPageController/ConfigScreenController.dart';
import 'Controllers/DataController/DataControllers.dart';
import 'Controllers/SearchController/SerchControllers.dart';
import 'Pages/SplashScree/SplashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await createDB();
  runApp(MyApp());
}

Future createDB() async {
  await DBHelper.getInstance().then((value) {
    print("Created...");
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        key: navigatorKey,
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeManager()),
          ChangeNotifierProvider(create: (_) => LoginController()),
          ChangeNotifierProvider(create: (_) => DashBoardCtrlProvider()),
          ChangeNotifierProvider(create: (_) => AuditCtrlProvider()),
          ChangeNotifierProvider(create: (_) => ConfigController()),
          ChangeNotifierProvider(create: (_) => Datactrls()),
          ChangeNotifierProvider(create: (_) => SearchCtrl()),
        ],
        child:
            Consumer<ThemeManager>(builder: (context, themes, Widget? child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Verifyt',
              getPages: Routes.allRoutes,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
                useMaterial3: true,
              ),
              home: const SplashScreenpage());
        }));
  }
}
