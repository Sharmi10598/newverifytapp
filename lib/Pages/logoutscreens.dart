import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verifytapp/Constant/ConstantRoutes.dart';
import 'package:verifytapp/Constant/Screen.dart';
import 'package:verifytapp/DBHelper/DBOperations.dart';
import '../Constant/Helper.dart';
import '../Controllers/DashBoardController/DashBoradControllers.dart';
import '../DBHelper/DBHelpers.dart';
import '../driftDB/driftTablecreation.dart';
import '../driftDB/driftoperation.dart';

class LogoutScreenPage extends StatefulWidget {
  const LogoutScreenPage({super.key});

  @override
  State<LogoutScreenPage> createState() => _LogoutScreenPageState();
}

class _LogoutScreenPageState extends State<LogoutScreenPage> {
  @override
  void initState() {
    super.initState();
    log('yessssssssss');
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

  Future<SharedPreferences> pref = SharedPreferences.getInstance();
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
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // title: Text("Are you sure?"),
        // content: Text("Do you want to exit?"),
        content: SizedBox(
          width: Screens.width(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: Screens.width(context),
                height: Screens.bodyheight(context) * 0.06,
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,

                      textStyle: const TextStyle(),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      )), //Radius.circular(6)
                    ),
                    child: const Text("Alert",
                        style: TextStyle(fontSize: 15, color: Colors.white))),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 40),
                  width: Screens.width(context) * 0.85,
                  child: const Divider(
                    color: Colors.grey,
                  )),
              Container(
                  alignment: Alignment.center,
                  // width: Screens.width(context)*0.5,
                  // padding: EdgeInsets.only(left:20),
                  child: const Text(
                    "Are you sure",
                    style: TextStyle(fontSize: 15),
                  )),
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              Container(
                  alignment: Alignment.center,
                  // padding: EdgeInsets.only(left:20),
                  child: const Text("Do you want to logout?",
                      style: TextStyle(fontSize: 15))),
              Container(
                  padding: const EdgeInsets.only(left: 40),
                  width: Screens.width(context) * 0.85,
                  child: const Divider(color: Colors.grey)),
              SizedBox(
                height: Screens.bodyheight(context) * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Screens.width(context) * 0.47,
                    height: Screens.bodyheight(context) * 0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,

                          // primary: theme.primaryColor,
                          textStyle: const TextStyle(color: Colors.white),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(0),
                          )),
                        ),
                        onPressed: () async {
                          final pref2 = await pref;
                          await pref2.remove('tenantId');
                          final database = (await AppDatabase.initialize())!;
                          Database db = (await DBHelper.getInstance())!;
                          await HelperFunctions
                              .clearCheckedTennetIDSharedPref();
                          await HelperFunctions
                              .clearCheckedDeviceIDSharedPref();
                          await HelperFunctions.clearWhsCode();
                          await HelperFunctions.clearUserCodeDSharedPref();
                          await HelperFunctions.clearPasswordSharedPreference();
                          await driftoperation.deletItemCodeData(database);
                          await driftoperation.deleteBinListItem(database);
                          await driftoperation.deleteListItem(database);
                          await driftoperation.deletHeaderItem(database);
                          await driftoperation.deleteChecklistMaster(database);
                          await driftoperation.deleteChecklistLine(database);
                          await driftoperation.deleteChecklistHeader(database);
                          await driftoperation.deletHeaderItem(database);
                          await driftoperation.deletHeaderItem(database);
                          await DBOperation.truncateScanpostDataT(db);
                          await DBOperation.truncateWarehouseDb(db);
                          await DBOperation.truncateAuditByDevice(db);
                          await DBOperation.truncateAuditByDevice(db);
                          await DBOperation.truncatedispval(db);
                          await DBOperation.truncheckListDataDB(db);
                          context.read<DashBoardCtrlProvider>().selectedIndex =
                              0;
                          Get.offAllNamed(ConstantRoutes.login);
                        },
                        child: const Text(
                          "Yes",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  SizedBox(
                    width: Screens.width(context) * 0.47,
                    height: Screens.bodyheight(context) * 0.06,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,

                          // primary: theme.primaryColor,
                          textStyle: const TextStyle(color: Colors.white),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(10),
                          )),
                        ),
                        onPressed: () {
                          setState(() {
                            Get.back();
                            context
                                .read<DashBoardCtrlProvider>()
                                .selectedIndex = 0;
                            context.read<DashBoardCtrlProvider>().onItemTapped(
                                context
                                    .read<DashBoardCtrlProvider>()
                                    .selectedIndex = 0);
                            // Get.toNamed(ConstantRoutes.dashboard);
                          });
                          // context.read<EnquiryUserContoller>().checkDialogCon();
                        },
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () => Navigator.of(context).pop(false),
        //     child: Text("No"),
        //   ),
        //   TextButton(
        //       onPressed: () {
        //         exit(0);
        //       },
        //       child: Text("yes"))
        // ],
      ),
    );
  }
}
