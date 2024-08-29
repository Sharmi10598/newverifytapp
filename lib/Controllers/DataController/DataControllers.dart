import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verifytapp/Constant/Configuration.dart';
import 'package:verifytapp/Services/LoadMasterApi/LoadBinMasterApi.dart';
import 'package:verifytapp/Services/LoadMasterApi/LoadItemMastersApi.dart';

import '../../Constant/Screen.dart';
import '../../DBHelper/DBHelpers.dart';
import '../../DBHelper/DBOperations.dart';
import '../../Model/AuditModel/AuditActionModel.dart';
import '../../Model/WareHouseModel/WarehouseDataModel.dart';
import '../../Services/LoadMasterApi/LoadGetStockMastersApi.dart';
import '../../Services/WareHouseApi/GetWareHouseApi.dart';
import '../../driftDB/driftTablecreation.dart';
import '../../driftDB/driftoperation.dart';
import '../AuditController/AuditControllers.dart';

class Datactrls extends ChangeNotifier {
  Config config = Config();
  init(
    BuildContext context,
  ) {
    clearAllData();
    callGetWhsListApi(context);
    getTablesLength();
  }

  clearAllData() {
    itemloading = false;
    stockloading = false;
    binloading = false;
    btnDisabled = false;
    itemLength = 0;
    stocklength = 0;
    binLength = 0;
    whsListtData = [];
    whsListDropData = [];
    auditActionHeaderList = [];
    auditActionLineList = [];
    auditActionBinMasterList = [];
    errorMsg = '';
    // selectedStockValue = null;
    selectwhs = true;

    notifyListeners();
  }

  bool itemloading = false;
  bool stockloading = false;
  bool binloading = false;
  bool btnDisabled = false;

  int itemLength = 0;
  int stocklength = 0;
  int binLength = 0;
  List<WareHouseListData> whsListtData = [];
  List<WareHouseListData> whsListDropData = [];
  final formKey = GlobalKey<FormState>();
  List<HeaderData> auditActionHeaderList = [];
  List<LineData> auditActionLineList = [];
  List<BinMasterData> auditActionBinMasterList = [];
  ViewDetailsData? itemViewDetails = ViewDetailsData();
  ViewDetailsData? stockViewDetails = ViewDetailsData();
  ViewDetailsData? binViewDetails = ViewDetailsData();

  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  bool selectwhs = true;
  String? selectedStockValue;
  String? selectedStockwhscode;
  String? itemLastDownTime;
  String? stockLastDownTime;
  String? binLastDownTime;
  String errorMsg = '';
  donwloadItemData() {
    log('Kkkkkkkkkkkkkkkkkkk1111');

    Future.delayed(Duration(seconds: 5)).then((values) {
      log('Kkkkkkkkkkkkkkkkkkk222');
      btnDisabled = false;
      itemloading = false;
      stockloading = false;
      binloading = false;
      notifyListeners();
    });
    notifyListeners();
  }

  checkTableEmpty(
    BuildContext context,
    ThemeData theme,
    String apiRes,
    String actionName,
  ) async {
    notifyListeners();
    final database = (await AppDatabase.initialize())!;

    List<LineData> getlineresult =
        await driftoperation.getallLineproduct(database);
    List<HeaderData> getheaderresult = await driftoperation.getallproduct(
      database,
    );
    List<BinMasterData> getBinResult =
        await driftoperation.getBinMasterdata(database);

    if (actionName == 'Item') {
      if (getheaderresult.isNotEmpty) {
        actionResetDialog(context, theme, apiRes, actionName);
        notifyListeners();
      }
    } else if (actionName == 'Stock') {
      if (getlineresult.isNotEmpty) {
        actionResetDialog(context, theme, apiRes, actionName);
        notifyListeners();
      }
    } else if (actionName == 'Bin') {
      if (getBinResult.isNotEmpty) {
        actionResetDialog(context, theme, apiRes, actionName);
        notifyListeners();
      }
    }

    notifyListeners();
  }

  actionResetDialog(
    BuildContext context,
    ThemeData theme,
    String apiRes,
    String actionName,
  ) async {
    final SharedPreferences pref2 = await pref;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Screens.width(context) * 0.8,
                            child: Center(
                                child: Text("Warning",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(apiRes),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Screens.width(context) * 0.445,
                          height: Screens.bodyheight(context) * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,

                                // primary: theme.primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(0),
                                )),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                "Continue",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          width: Screens.width(context) * 0.445,
                          height: Screens.bodyheight(context) * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,

                                // primary: theme.primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(8),
                                )),
                              ),
                              onPressed: () async {
                                final database =
                                    (await AppDatabase.initialize())!;
                                if (actionName == 'Item') {
                                  await driftoperation
                                      .deletHeaderItem(database)
                                      .then((value) {
                                    pref2.remove('itemLastDownTime');
                                    getTablesLength();
                                    Get.back();

                                    notifyListeners();
                                  });
                                } else if (actionName == 'Bin') {
                                  await driftoperation
                                      .deleteBinListItem(database)
                                      .then((value) {
                                    pref2.remove('binLastDownTime');
                                    getTablesLength();
                                    Get.back();

                                    notifyListeners();
                                  });
                                } else if (actionName == 'Stock') {
                                  selectedStockValue = null;
                                  await driftoperation
                                      .deleteListItem(database)
                                      .then((value) {
                                    pref2.remove('stockLastDownTime');
                                    getTablesLength();

                                    notifyListeners();
                                    Get.back();
                                  });
                                }
                                notifyListeners();
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ])),
            );
          });
        });
  }

  getTablesLength() async {
    final database = (await AppDatabase.initialize())!;
    final SharedPreferences pref2 = await pref;
    List<LineData> getlineresult =
        await driftoperation.getallLineproduct(database);
    List<HeaderData> getheaderresult =
        await driftoperation.getallproduct(database);
    List<BinMasterData> getbinresult =
        await driftoperation.getBinMasterdata(database);

    itemLength = getheaderresult.length;
    stocklength = getlineresult.length;
    binLength = getbinresult.length;
    String itemLastTime = pref2.getString("itemLastDownTime") ?? '';
    String stockLastTime = pref2.getString("stockLastDownTime") ?? '';
    String binLastTime = pref2.getString("binLastDownTime") ?? '';

    itemLastDownTime = itemLastTime.isNotEmpty
        ? config.aligndateforTimeStampt(itemLastTime)
        : '';

    stockLastDownTime = stockLastTime.isNotEmpty
        ? config.aligndateforTimeStampt(stockLastTime)
        : '';

    binLastDownTime = binLastTime.isNotEmpty
        ? config.aligndateforTimeStampt(binLastTime)
        : '';

    notifyListeners();
  }

  callGetWhsListApi(
    BuildContext context,
  ) async {
    Database db = (await DBHelper.getInstance())!;
    final theme = Theme.of(context);
    whsListtData = [];
    errorMsg = '';
    await WareHouseDataApi.getData().then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        whsListtData = value.whsListData;
        log('whsListtDatawhsListtData::${whsListtData.length}');
        await DBOperation.truncateWarehouseDb(db);

        await DBOperation.insertWhsListData(db, whsListtData)
            .then((value) async {
          await getwhsdropList();
        });
        log('whsListtDatawhsListtData::${whsListtData.length}');
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        apiResponseDialog(context, theme, value.respCode, value.respDesc);
        errorMsg = value.respDesc;
        notifyListeners();
      } else {
        errorMsg = value.respDesc;
      }
    });

    notifyListeners();
  }

  callGetItemMasterApi(BuildContext context, ThemeData theme) async {
    final database = (await AppDatabase.initialize())!;
    final SharedPreferences pref2 = await pref;

    auditActionHeaderList = [];
    errorMsg = '';
    await GetItemMasterApi.getData('All', 'Item').then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        auditActionHeaderList = value.auditItemData;
        if (auditActionHeaderList.isNotEmpty) {
          await driftoperation
              .insertdriftdatabase(auditActionHeaderList, database)
              .then((value) async {
            itemLastDownTime = '';
            String lastdowntime = config.firstDate();

            btnDisabled = false;
            itemloading = false;
            stockloading = false;
            binloading = false;
            notifyListeners();

            List<HeaderData> getheaderresult =
                await driftoperation.getallproduct(database);
            itemLength = getheaderresult.length;

            pref2.setString("itemLastDownTime", lastdowntime);
            String itemTime = pref2.getString("itemLastDownTime").toString();
            itemLastDownTime = config.aligndateforTimeStampt(itemTime);

            DataSuccessMsg(
                context, theme, 'ItemMaster Downloaded Successfully..!!');
            itemViewDetails = ViewDetailsData(
                actionName: 'Item',
                itemslength: getheaderresult.length,
                lasttimestamp: itemLastDownTime,
                docEntry: 0);
          });
        }
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        apiResponseDialog(context, theme, value.respCode, value.respDesc);
        errorMsg = value.respDesc;
        btnDisabled = false;
        itemloading = false;
        stockloading = false;
        binloading = false;

        notifyListeners();
      } else {
        errorMsg = value.respDesc;
        btnDisabled = false;
        itemloading = false;
        stockloading = false;
        binloading = false;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  void apiResponseDialog(
      BuildContext context, ThemeData theme, String resCode, String apiRes) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            // final theme=Theme.of(context)
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Container(
                        width: Screens.width(context) * 0.8,
                        child: Center(
                            child: Text("Alert",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text('${resCode}..!!  ' + apiRes),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            foregroundColor: Colors.white,
                            backgroundColor: theme.primaryColor),
                        onPressed: () {
                          Get.back();
                          // context.read<DashBoardCtrlProvider>().selectedIndex =
                          //     1;
                          // Get.offAllNamed(ConstantRoutes.dashboard);
                        },
                        child: const Text('OK'))
                  ])),
            );
          });
        });
  }

  callGettStocksMaster(BuildContext context, ThemeData theme) async {
    Database db = (await DBHelper.getInstance())!;
    final database = (await AppDatabase.initialize())!;
    final SharedPreferences pref2 = await pref;

    auditActionLineList = [];
    errorMsg = '';
    await GetLoadStocksMastersApi.getData(selectedStockwhscode!, 'Stock')
        .then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        auditActionLineList = value.auditData;
        if (auditActionLineList.isNotEmpty) {
          await driftoperation
              .insertdriftLinedatabase(auditActionLineList, database)
              .then((value) async {
            stockLastDownTime = '';
            String lastdowntime = config.firstDate();
            // stockLastDownTime = config.aligndateforTimeStampt(lastdowntime);
            List<LineData> getlineresult =
                await driftoperation.getallLineproduct(database);

            stocklength = getlineresult.length;

            pref2.setString("stockLastDownTime", lastdowntime);
            String stockTime = pref2.getString("stockLastDownTime").toString();
            stockLastDownTime = config.aligndateforTimeStampt(stockTime);
            DataSuccessMsg(
                context, theme, 'StockSnap Downloaded Successfully..!!');
            stockViewDetails = ViewDetailsData(
                actionName: 'Stock',
                itemslength: getlineresult.length,
                lasttimestamp: stockLastDownTime,
                docEntry: 0);
            btnDisabled = false;
            itemloading = false;
            stockloading = false;
            binloading = false;
            notifyListeners();
          });
          ;
        }
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        apiResponseDialog(context, theme, value.respCode, value.respDesc);
        errorMsg = value.respDesc;
        btnDisabled = false;
        itemloading = false;
        stockloading = false;
        binloading = false;

        notifyListeners();
      } else {
        errorMsg = value.respDesc;
        btnDisabled = false;
        itemloading = false;
        stockloading = false;
        binloading = false;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  callGetBinMasterApi(BuildContext context, ThemeData theme) async {
    final database = (await AppDatabase.initialize())!;
    Database db = (await DBHelper.getInstance())!;
    auditActionBinMasterList = [];
    errorMsg = '';
    await GetBinMasterApi.getData('All', 'Bin').then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        auditActionBinMasterList = value.auditData;
        if (auditActionBinMasterList.isNotEmpty) {
          await driftoperation
              .insertBinMasterdatabase(auditActionBinMasterList, database)
              .then((value) async {
            binLastDownTime = '';
            String lastdowntime = config.firstDate();
            // binLastDownTime = config.aligndateforTimeStampt(lastdowntime);
            List<BinMasterData> getbinresult =
                await driftoperation.getBinMasterdata(database);
            binLength = getbinresult.length;
            final SharedPreferences pref2 = await pref;
            pref2.setString("binLastDownTime", lastdowntime);
            String bintime = pref2.getString("binLastDownTime") ?? '';

            binLastDownTime = config.aligndateforTimeStampt(bintime);
            DataSuccessMsg(
                context, theme, 'BinMaster Downloaded Successfully..!!');
            binViewDetails = ViewDetailsData(
                actionName: 'Bin',
                itemslength: getbinresult.length,
                lasttimestamp: binLastDownTime,
                docEntry: 0);
            btnDisabled = false;
            itemloading = false;
            stockloading = false;
            binloading = false;
            notifyListeners();
          });
          ;
        }
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        apiResponseDialog(context, theme, value.respCode, value.respDesc);
        errorMsg = value.respDesc;

        btnDisabled = false;
        itemloading = false;
        stockloading = false;
        binloading = false;

        notifyListeners();
      } else {
        errorMsg = value.respDesc;

        btnDisabled = false;
        itemloading = false;
        stockloading = false;
        binloading = false;
        notifyListeners();
      }
    });

    notifyListeners();
  }

  getwhsdropList() async {
    Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> result2 = await DBOperation.getWhsDataList(db);
    log('result2result2::${result2.length}');
    if (result2.isNotEmpty) {
      whsListDropData = [];
      for (int i = 0; i < result2.length; i++) {
        whsListDropData.add(WareHouseListData(
            // address1: result2[i]['Address1'].toString(),
            // address2: result2[i]['Address2'].toString(),
            // address3: result2[i]['Address3'].toString(),
            // city: result2[i]['City'].toString(),
            // country: result2[i]['Country'].toString(),
            // createdBy: int.parse(result2[i]['CreatedBy'].toString()),
            // createdOn: result2[i]['CreatedOn'].toString(),
            // gstNo: result2[i]['GSTNo'].toString(),
            // longitude: result2[i]['Longitude'] != null
            //     ? result2[i]['Longitude'].toString()
            //     : "",
            // lotitude: result2[i]['Latitude'] != null
            //     ? result2[i]['Latitude'].toString()
            //     : '',
            // picode: result2[i]['Picode'].toString(),
            // primaryContact: result2[i]['PrimaryContact'].toString(),
            // primaryEmail: result2[i]['PrimaryEmail'].toString(),
            // state: result2[i]['State'].toString(),
            // status: int.parse(result2[i]['Status'].toString()),
            // traceid: result2[i]['Traceid'].toString(),
            // updatedBy: result2[i]['UpdatedBy'] != null
            //     ? int.parse(result2[i]['UpdatedBy'].toString())
            //     : 0,
            // updatedOn: result2[i]['UpdatedOn'] != null
            //     ? result2[i]['UpdatedOn'].toString()
            //     : '',
            whsCode: result2[i]['WhsCode'].toString(),
            whsName: result2[i]['WhsName'].toString()));
      }
    }
    log('whsListDropDatawhsListDropData::${whsListDropData.length}');
    notifyListeners();
  }

  selectStockWhsCode() {
    for (var i = 0; i < whsListDropData.length; i++) {
      if (selectedStockValue == whsListDropData[i].whsName) {
        selectedStockwhscode = whsListDropData[i].whsCode;
      }
      notifyListeners();
    }
    notifyListeners();
  }

  DataSuccessMsg(BuildContext context, ThemeData theme, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            // final theme=Theme.of(context)
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Container(
                        width: Screens.width(context) * 0.8,
                        child: Center(
                            child: Text("Success",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text('$msg'),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            foregroundColor: Colors.white,
                            backgroundColor: theme.primaryColor),
                        onPressed: () {
                          Get.back();
                          // context.read<DashBoardCtrlProvider>().selectedIndex =
                          //     1;
                          // Get.offAllNamed(ConstantRoutes.dashboard);
                        },
                        child: const Text('OK'))
                  ])),
            );
          });
        });
  }
}
