import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DashBoardController/DashBoradControllers.dart';

class ConfigController extends ChangeNotifier {
  init() {
    clearAllData();
  }

  static bool isScanner = false;
  clearAllData() {
    isScanner = false;
    notifyListeners();
  }

  void toggleSwitch(bool value) {
    isScanner = !isScanner;
  }
  
  DateTime? currentBackPressHome;
  Future<bool> onBackPressHome(BuildContext context) {
    log('fffffffffffffffff');
    DateTime now = DateTime.now();
    if (currentBackPressHome == null ||
        now.difference(currentBackPressHome!) > const Duration(seconds: 2)) {
      currentBackPressHome = now;
      context.read<DashBoardCtrlProvider>().onItemTapped(0);
      return Future.value(false);
    }
    return Future.value(false);
  }
}
