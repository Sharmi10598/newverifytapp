import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verifytapp/driftDB/driftTablecreation.dart';

import '../../Constant/ConstantRoutes.dart';
import '../../Constant/Helper.dart';
import '../../Constant/Screen.dart';
import '../../Controllers/DashBoardController/DashBoradControllers.dart';
import '../../DBHelper/DBHelpers.dart';
import '../../DBHelper/DBOperations.dart';
import '../../driftDB/driftoperation.dart';

class LogoutAlertDialog extends StatefulWidget {
  const LogoutAlertDialog({super.key});

  @override
  State<LogoutAlertDialog> createState() => _LogoutAlertDialogState();
}

class _LogoutAlertDialogState extends State<LogoutAlertDialog> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  DateTime? currentBackPress;
  Future<bool> onBackPressHome(BuildContext context) {
    DateTime now = DateTime.now();
    if (currentBackPress == null ||
        now.difference(currentBackPress!) > const Duration(seconds: 2)) {
      Get.back();
      currentBackPress = now;
      context.read<DashBoardCtrlProvider>().onItemTapped(0);

      return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => onBackPressHome(context),
      child: AlertDialog(
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
                          await HelperFunctions.clearSaveHostSP();
                          await HelperFunctions.clearStockHostSP();
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
                          await DBOperation.truncateCheckListT(db);
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
