import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../Constant/ConstantRoutes.dart';
import '../../Constant/ConstantSapValues.dart';
import '../../Constant/Helper.dart';
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

  //forceupdate
  Future<void> showVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // log("packageInfo.version::" + packageInfo.version.toString());
    ConstantValues.appversion = packageInfo.version;
    // print(
    //     "packageInfo.versionConstant::" + ConstantValues.appversion.toString());
    notifyListeners();
  }

  checkStartingPage(String? pageName, int? docEntry) async {
    if (await HelperFunctions.getOnBoardSharedPreference() == true) {
      Get.offAllNamed(ConstantRoutes.splashScreen);
    } else {
      Get.offAllNamed(ConstantRoutes.dashboard);
    }
  }
}
