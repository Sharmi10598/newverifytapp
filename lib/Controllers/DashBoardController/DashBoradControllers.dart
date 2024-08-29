import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verifytapp/Constant/Configuration.dart';
import 'package:verifytapp/Constant/ConstantRoutes.dart';
import 'package:verifytapp/Constant/Helper.dart';
import 'package:verifytapp/DBHelper/DBOperations.dart';
import 'package:verifytapp/Pages/DashBoardPages/Widgets/HomePage.dart';
import '../../Constant/LocalUrl/GetLocalUrl.dart';
import '../../Constant/Screen.dart';
import '../../DBHelper/DBHelpers.dart';
import '../../Model/AuditModel/AuditByDeviceModel.dart';
import '../../Pages/AuditPages/Screens/AuditScreens.dart';
import '../../Pages/ConfigPage/ConfigPageScreen.dart';
import '../../Pages/DataScreen/Widgets/DataDownloadScreen.dart';
import '../../Pages/SearchScreen/widgets/InwardScreen.dart';
import '../../Pages/logoutscreens.dart';
import '../../Services/GetAuditApi/GetAuditByDeviceAPI.dart';
import '../../driftDB/driftTablecreation.dart';
import '../../driftDB/driftoperation.dart';

class DashBoardCtrlProvider extends ChangeNotifier {
  init() {
    setURL();
    notifyListeners();
  }

  Config configg = Config();
  checkNeworkConnectivity() async {
    bool? noNetbool = await configg.haveNoInterNet();
    if (noNetbool == false) {
      // log('netboolnetboolnetbool::$noNetbool');
      callGetAuditApi();
    } else {
      log('falsefalsddddde');
      await getAuditBydeviceData();
    }
    notifyListeners();
  }

  getAuditBydeviceData() async {
    openAuditList = [];

    Database db = (await DBHelper.getInstance())!;

    List<Map<String, Object?>> result2 =
        await DBOperation.getAuditByDervice(db);
    log('result2result2result2result2result2::${result2.length}');
    if (result2.isNotEmpty) {
      openAuditList = [];
      for (var i = 0; i < result2.length; i++) {
        if (result2[i]['Status'].toString() == 'Open' ||
            result2[i]['Status'].toString() == 'In-Process' ||
            result2[i]['Status'].toString() == 'Starting') {
          openAuditList.add(GetAuditDataModel(
              auditFrom: result2[i]['AuditFrom'].toString(),
              user: result2[i]['User'].toString(),
              percent: result2[i]['Percent'] != null
                  ? double.parse(result2[i]['Percent'].toString())
                  : 0,
              unitsScanned: result2[i]['UnitsScanned'] != null
                  ? int.parse(result2[i]['UnitsScanned'].toString())
                  : 0,
              totalItems: result2[i]['TotalItems'] != null
                  ? int.parse(result2[i]['TotalItems'].toString())
                  : 0,
              auditTo: result2[i]['AuditTo'].toString(),
              // blockTrans: bool.parse(result2[i][' blockTrans'].toString()),
              createdBy: result2[i]['CreatedBy'] != null
                  ? int.parse(result2[i]['CreatedBy'].toString())
                  : 0,
              createdDatetime: result2[i]['CreatedDatetime'].toString(),
              docDate: result2[i]['DocDate'].toString(),
              docEntry: result2[i]['DocEntry'] != null
                  ? int.parse(result2[i]['DocEntry'].toString())
                  : 0,
              docNum: result2[i]['DocNum'] != null
                  ? int.parse(result2[i]['DocNum'].toString())
                  : 0,
              endDate: result2[i]['EndDate'].toString(),
              remarks: result2[i]['Remarks'].toString(),
              // repeat: result2[i]['repeat'] != null
              //     ? bool.parse(result2[i]['repeat'].toString())
              //     : false,
              repeatDay: result2[i]['RepeatDay'] != null
                  ? int.parse(result2[i]['RepeatDay'].toString())
                  : 0,
              repeatFrequency: result2[i]['RepeatFrequency'].toString(),
              scheduleName: result2[i]['ScheduleName'].toString(),
              startDate: result2[i]['StartDate'].toString(),
              status: result2[i]['Status'].toString(),
              traceid: result2[i]['Traceid'].toString(),
              updatedBy: result2[i]['UpdatedBy'] != null
                  ? int.parse(result2[i]['UpdatedBy'].toString())
                  : 0,
              updatedDatetime: result2[i]['UpdatedDatetime'].toString(),
              whsCode: result2[i]['WhsCode'] != null
                  ? result2[i]['WhsCode'].toString()
                  : '',
              deviceCode: ''));
          notifyListeners();
        }
      }
      notifyListeners();
    }
    notifyListeners();
  }

  clearallData() {
    int selectedIndex = 0;
  }

  int selectedIndex = 0;
  List<GetAuditDataModel> openAuditList = [];
  List<GetAuditDataModel> getAllAuditList = [];

  List<Widget> widgetOptions = [
    const HomePage(),
    const AuditAllScreens(),
    const DataScreenPage(),
    const SearchScreenPage(),
    const ConfigScreenPage(),
    const LogoutScreenPage()

    //  Text('Config',
    //     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  ];

  onItemTapped(int index) {
    selectedIndex = 0;
    selectedIndex = index;
    notifyListeners();
  }

  onLogoutTapped(
    int index,
  ) {
    selectedIndex = 0;
    selectedIndex = index;
    Get.offAllNamed(ConstantRoutes.dashboard);
    notifyListeners();
  }

  void onItemDetTapped(
    int index,
  ) {
    log('Index ItemDet::$index');
    selectedIndex = index;
    notifyListeners();
    Get.offAllNamed(ConstantRoutes.dashboard);
  }

  apiResponseDialog(BuildContext context, ThemeData theme, String apiRes) {
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Screens.width(context) * 0.8,
                            child: Center(
                                child: Text("Alert",
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

  setURL() async {
    String? getCustUrl = await HelperFunctions.getHostDSP();
    String? getStockUrl = await HelperFunctions.getStockHostDSP();

    log('getStockUrlget22:$getStockUrl');
    // String hostip = '';
    // if (getCustUrl != null) {
    //   for (int i = 0; i < getCustUrl.length; i++) {
    //     if (getCustUrl[i] == ":") {
    //       break;
    //     }
    //     // log("for ${hostip}");
    //     hostip = hostip + getCustUrl[i];
    //   }
    // }

    // log("for last ${hostip}");
    // HelperFunctions.saveHostSP(hostip);
    // ConstantValues.userNamePM = await HelperFunctions.getUserName();
    Url.queryApi = "${getCustUrl.toString()}/api/";
    Url.stockSnapApi = "${getStockUrl.toString()}/api/";
    log('  Url.queryApi Url.queryApi333::${Url.queryApi}:::stockSnapApi::${Url.stockSnapApi}');
  }

  callGetAuditApi() async {
    openAuditList = [];
    Database db = (await DBHelper.getInstance())!;
    List<GetAuditDataModel> getAuditList2 = [];
    String? deviceId = await HelperFunctions.getDeviceIDSharedPreference();
    await GetAuditByDeviceApi.getData(deviceId!).then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        getAuditList2 = value.auditData;
        openAuditList = [];
        DBOperation.truncateAuditByDevice(db);
        DBOperation.insertAuditByDervice(db, getAuditList2);

        List<Map<String, Object?>> result2 =
            await DBOperation.getAuditByDervice(db);
        if (result2.isNotEmpty) {
          openAuditList = [];
          for (var i = 0; i < result2.length; i++) {
            if (result2[i]['Status'].toString() == 'Open' ||
                result2[i]['Status'].toString() == 'In-Process' ||
                result2[i]['Status'].toString() == 'Starting') {
              openAuditList.add(GetAuditDataModel(
                  auditFrom: result2[i]['AuditFrom'].toString(),
                  user: result2[i]['User'].toString(),
                  percent: result2[i]['Percent'] != null
                      ? double.parse(result2[i]['Percent'].toString())
                      : 0,
                  unitsScanned: result2[i]['UnitsScanned'] != null
                      ? int.parse(result2[i]['UnitsScanned'].toString())
                      : 0,
                  totalItems: result2[i]['TotalItems'] != null
                      ? int.parse(result2[i]['TotalItems'].toString())
                      : 0,
                  auditTo: result2[i]['AuditTo'].toString(),
                  // blockTrans: bool.parse(result2[i][' blockTrans'].toString()),
                  createdBy: result2[i]['CreatedBy'] != null
                      ? int.parse(result2[i]['CreatedBy'].toString())
                      : 0,
                  createdDatetime: result2[i]['CreatedDatetime'].toString(),
                  docDate: result2[i]['DocDate'].toString(),
                  docEntry: result2[i]['DocEntry'] != null
                      ? int.parse(result2[i]['DocEntry'].toString())
                      : 0,
                  docNum: result2[i]['DocNum'] != null
                      ? int.parse(result2[i]['DocNum'].toString())
                      : 0,
                  endDate: result2[i]['EndDate'].toString(),
                  remarks: result2[i]['Remarks'].toString(),
                  // repeat: result2[i]['repeat'] != null
                  //     ? bool.parse(result2[i]['repeat'].toString())
                  //     : false,
                  repeatDay: result2[i]['RepeatDay'] != null
                      ? int.parse(result2[i]['RepeatDay'].toString())
                      : 0,
                  repeatFrequency: result2[i]['RepeatFrequency'].toString(),
                  scheduleName: result2[i]['ScheduleName'].toString(),
                  startDate: result2[i]['StartDate'].toString(),
                  status: result2[i]['Status'].toString(),
                  traceid: result2[i]['Traceid'].toString(),
                  updatedBy: result2[i]['UpdatedBy'] != null
                      ? int.parse(result2[i]['UpdatedBy'].toString())
                      : 0,
                  updatedDatetime: result2[i]['UpdatedDatetime'].toString(),
                  whsCode: result2[i]['WhsCode'] != null
                      ? result2[i]['WhsCode'].toString()
                      : '',
                  deviceCode: ''));
            }
          }
        }

        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        notifyListeners();
      }
    });
    notifyListeners();
  }

  File? source1;
  Directory? copyTo;
  Future<File> getPathOFDB() async {
    final dbFolder = await getDatabasesPath();
    File source1 = File('$dbFolder/Verifyt.db');
    return Future.value(source1);
  }

  Future<Directory> getDirectory() async {
    Directory copyTo = Directory("/storage/emulated/0/sqbackup");
    return Future.value(copyTo);
  }

  Future<void> copyDatabaseToExternalStorage() async {
    // Request permissions first
    await getPermissionStorage();

    final internalDbPath = await getDatabasesPath();
    final dbFile = File('$internalDbPath/Verifyt.db');
    log("message::" + dbFile.toString());

    final externalDir = await getExternalStorageDirectory();
    log("message::" + externalDir.toString());
    final externalDbPath = '${externalDir?.path}/Verifyt.db';

    if (await dbFile.exists()) {
      await dbFile.copy(externalDbPath);
      print("Database copied to: $externalDbPath");
      showSnackBars("${externalDbPath} db saved Successfully", Colors.green);
    } else {
      print("Database file does not exist.");
    }
  }

  Future<bool> getPermissionStorage() async {
    try {
      var statusStorage = await Permission.storage.status;
      if (statusStorage.isDenied) {
        Permission.storage.request();
        return Future.value(false);
      }
      if (statusStorage.isGranted) {
        return Future.value(true);
      }
    } catch (e) {
      showSnackBars("$e", Colors.red);
    }
    return Future.value(false);
  }

  showSnackBars(String e, Color color) {
    Get.showSnackbar(GetSnackBar(
      duration: Duration(seconds: 5),
      title: "Notify",
      message: e,
    ));
  }

  Future<String> createDirectory() async {
    try {
      await copyTo!.create();
      String newPath = copyTo!.path;
      createDBFile(newPath);
      return newPath;
    } catch (e) {
      showSnackBars("$e", Colors.red);
    }
    return 'null';
  }

  createDBFile(String path) async {
    log("path::" + path.toString());
    try {
      String getPath = "$path/Verifyt.db";
      await source1!.copy(getPath);
      showSnackBars("Created!!...", Colors.green);
    } catch (e) {
      log("eeeee::" + e.toString());
      showSnackBars("$e", Colors.red);
    }
  }
}
