import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Pages/LogoutScreens/LogoutDialog.dart';
import '../../Controllers/DashBoardController/DashBoradControllers.dart';

class LogoutScreenPage extends StatefulWidget {
  const LogoutScreenPage({super.key});

  @override
  State<LogoutScreenPage> createState() => _LogoutScreenPageState();
}

class _LogoutScreenPageState extends State<LogoutScreenPage> {
  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      onBackPressLogout();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // final localizations = Localizations.of(context, AppLocalizations);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => onBackPressHome(context),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text('Logout'),
            ),
            Container(
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  DateTime? currentBackPressHome;
  Future<bool> onBackPressHome(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPressHome == null ||
        now.difference(currentBackPressHome!) > const Duration(seconds: 2)) {
      currentBackPressHome = now;

      context.read<DashBoardCtrlProvider>().onItemTapped(0);

      return Future.value(false);
    }
    return Future.value(false);
  }

  onBackPressLogout() {
    final theme = Theme.of(context);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return LogoutAlertDialog();
        });
  }
}
