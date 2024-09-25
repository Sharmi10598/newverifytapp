import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verifytapp/Constant/ConstantRoutes.dart';
import 'package:verifytapp/Constant/Screen.dart';
import 'package:verifytapp/Pages/ForceUpdateScreens/Configuration.dart';
import '../../Constant/Configuration.dart';
import '../../Constant/ConstantSapValues.dart';
import '../../Constant/Helper.dart';
import '../../Constant/LocalUrl/GetLocalUrl.dart';
import '../../Model/LoginModel/loginmodel.dart';
import '../../Services/LoginAPI/loginApi.dart';

class SplashScreenpage extends StatefulWidget {
  const SplashScreenpage({super.key});

  @override
  State<SplashScreenpage> createState() => SplashScreenpageState();
}

class SplashScreenpageState extends State<SplashScreenpage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    callTimeEnableMethod();
  }

  String userName = '';
  static String erroMsgg = '';

  String passWord = '';
  bool isLoading = true;

  static const platform = MethodChannel('com.buson.verifytapp/time');
  String _networkTimeStatus = 'Unknown';
  Future<void> _openDateTimeSettings() async {
    Get.back();
    try {
      await platform.invokeMethod('openDateTimeSettings');
      // Wait for a short time to allow settings to be applied.
      await Future.delayed(const Duration(seconds: 1));
      _checkAutomaticTimeZoneSetting();
    } on PlatformException catch (e) {
      log('$e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAutomaticTimeZoneSetting();
    }
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);

  //   super.dispose();
  // }

  Config configg = Config();
  Future<void> _checkAutomaticTimeZoneSetting() async {
    bool isAutomatic;
    String networkTimeStatuss = '';
    _networkTimeStatus = '';
    try {
      isAutomatic = await platform.invokeMethod('checkNetworkTime');
      networkTimeStatuss = isAutomatic ? 'Enabled' : 'Disabled';
      _networkTimeStatus = networkTimeStatuss;

      if (_networkTimeStatus == 'Enabled') {
        showVersion();
        checkVesionNum(context);

        // bool? isNoNetwork = await configg.haveNoInterNet();
        // if (isNoNetwork == true) {
        //   validateMethod(context);
        // } else {
        //   checkLoginPage();
        // }

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Automatic time zone is already enabled.'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      } else if (_networkTimeStatus == 'Disabled') {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content:
                    const Text('Enable Network-Provided Time on Your Device '),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openDateTimeSettings();
                      },
                      child: const Text('OK'))
                ],
              );
            });
      }
    } on PlatformException catch (e) {
      log(e.toString());
      isAutomatic = false;
    }
  }

  callTimeEnableMethod() {
    // WidgetsBinding.instance.addObserver(this);
    _networkTimeStatus = '';
    _checkAutomaticTimeZoneSetting();
  }

  setURL() async {
    String? getCustUrl = await HelperFunctions.getHostDSP();
    String? getStockUrl = await HelperFunctions.getStockHostDSP();

    log('getStockUrlget44t:$getCustUrl');
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
    // HelperFunctions.saveHostSP(hostip);
    Url.queryApi = "${getCustUrl.toString()}/api/";
    Url.stockSnapApi = "${getStockUrl.toString()}/api/";
    log('Url.queryApi Url.queryApi222::${Url.queryApi}:::stockSnapApi::${Url.stockSnapApi}');
  }

  validateMethod(BuildContext context) async {
    PostLoginData postLoginData = PostLoginData();
    String? fcm2 = await HelperFunctions.getFCMTokenSharedPreference();
    if (fcm2 == null) {
      fcm2 = "HGHJGFGHGGFD897657JKGJH";
      // fcm2 = (await getToken())!;
      // print("FCM Token: $fcm2");
      await HelperFunctions.saveFCMTokenSharedPreference(fcm2);
    }
    String? deviceID = await HelperFunctions.getDeviceIDSharedPreference();
    // log("deviceID:::$deviceID");
    if (deviceID == null) {
      deviceID = await Config.getdeviceId();
      // print("deviceID::$deviceID");
      await HelperFunctions.saveDeviceIDSharedPreference(deviceID!);
    }
    postLoginData.tenentID =
        (await HelperFunctions.getTenetIDSharedPreference1())!;
    postLoginData.deviceCode =
        await HelperFunctions.getDeviceIDSharedPreference();

    postLoginData.fcmToken =
        await HelperFunctions.getFCMTokenSharedPreference();

    postLoginData.username = userName;
    postLoginData.password = passWord;
    String? model = await Config.getdeviceModel();
    String? brand = await Config.getdeviceBrand();

    postLoginData.devicename = '$brand $model';
    ConstantValues.tenentID =
        await HelperFunctions.getTenetIDSharedPreference();
    // log('DDDDDDDDDDDDD:::${Url.queryApi}');
    await LoginAPi.getData(postLoginData).then((value) async {
      if (value.resCode! >= 200 && value.resCode! <= 200) {
        await HelperFunctions.saveTokenSharedPreference(value.token!);
        ConstantValues.token = value.token!;
        log('ConstantValues.token111::${ConstantValues.token}');
        await HelperFunctions.savewhseCode(value.whsCode!);
        String? whsCode = await HelperFunctions.getWhsCode();
        // log('whsCodewhsCodewhsCodewhsCode::::$whsCode');
        await HelperFunctions.saveUserLoggedInSharedPreference(true);

        Get.offAllNamed(ConstantRoutes.dashboard);

        log("message");
      } else if (value.resCode! >= 400 && value.resCode! <= 410) {
        // log('value.respDescvalue.respDesc::${value.respDesc}');
        userName = '';
        passWord = '';

        Get.offAllNamed(ConstantRoutes.login);
      }
    });
  }

  checkLoginPage() async {
    // log(await HelperFunctions.getLogginUserCodeSharedPreference());
    userName = await HelperFunctions.getLogginUserCodeSharedPreference() ?? '';
    passWord = await HelperFunctions.getPasswordSharedPreference() ?? '';
    // ConstantValues.token = (await HelperFunctions.getTokenSharedPreference())!;
    log("userName $userName");
    log("passWord$passWord");
    Future.delayed(const Duration(seconds: 3), () async {
      isLoading = false;
      if (userName.isNotEmpty && passWord.isNotEmpty) {
        bool? isNoNetwork = await configg.haveNoInterNet();
        if (isNoNetwork == false) {
          await setURL();
          validateMethod(context);
        } else {
          setURL();
          Get.offAllNamed(ConstantRoutes.dashboard);
        }
      } else {
        setState(() {
          log('message1111');
          userName = '';
          passWord = '';
          Get.offAllNamed(ConstantRoutes.login);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            left: Screens.padingHeight(context) * 0.03,
            right: Screens.padingHeight(context) * 0.03),
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image:
                DecorationImage(image: AssetImage('assets/appiconlaunch.png'))),
        height: Screens.fullHeight(context),
        width: Screens.width(context),
        child: SpinKitThreeBounce(
          size: Screens.padingHeight(context) * 0.04,
          color: Colors.black,
        ),
        // child: const Image(image: AssetImage('assets/Designer.png')),
      ),
    );
  }

  Future<void> showVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // log("packageInfo.version::" + packageInfo.version.toString());
    ConstantValues.appversion = packageInfo.version;
    //   print(
    //       "packageInfo.versionConstant::" + ConstantValues.appversion.toString());
  }

  bool visibleLoading = true;
  String? plyStoreVersionNumber = '';
  void checkVesionNum(BuildContext context) async {
    CheckVersionConfig checkverConfig = CheckVersionConfig();

    visibleLoading = true;
    plyStoreVersionNumber =
        await checkverConfig.getStoreVersion('com.buson.verifytapp');
    if (plyStoreVersionNumber == ConstantValues.appversion) {
      await checkLoginPage();

      log('versionNumber11::$plyStoreVersionNumber::AppVersionversion11::${ConstantValues.appversion}');
    } else {
      final theme = Theme.of(context);
      log('versionNumber22::$plyStoreVersionNumber::AppVersionversion22::${ConstantValues.appversion}');

      await Future.delayed(
        const Duration(seconds: 1),
        () {
          visibleLoading = true;
          updateDialog();
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     duration: const Duration(seconds: 7),
          //     backgroundColor: Colors.white,
          //     content: Text(
          //       'Please Download the Latest Version From PalyStore',
          //       style: TextStyle(color: theme.primaryColor),
          //     ),
          //   ),
          // );
        },
      );
    }
  }

  updateDialog() {
    final theme = Theme.of(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              width: Screens.width(context),
              height: Screens.bodyheight(context) * 0.27,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update available",
                    style: theme.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: Screens.bodyheight(context) * 0.01,
                  ),
                  Text(
                    "There is a new version of the app",
                    style: theme.textTheme.bodyMedium,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          height: Screens.bodyheight(context) * 0.08,
                          width: Screens.width(context) * 0.18,
                          padding: EdgeInsets.all(
                              Screens.bodyheight(context) * 0.008),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[200]),
                          child: Image.asset(
                            'assets/appiconlaunch.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(
                              Screens.bodyheight(context) * 0.008),
                          // decoration: BoxDecoration(
                          //   borderRadius: BorderRadius.circular(5),
                          //   color: Colors.grey[200]
                          // ),
                          child: Text(
                            'Version : ${plyStoreVersionNumber}',
                            style: theme.textTheme.bodySmall!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // context
                  // .read<ConfigurationContoller>()
                  // .checkStartingPage(pagename, docEntry);
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: Screens.width(context) * 0.25,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                            ),
                            onPressed: () async {
                              if (Platform.isAndroid || Platform.isIOS) {
                                final appId = Platform.isAndroid
                                    ? 'com.buson.verifytapp'
                                    : 'com.buson.verifytapp';
                                final url = Uri.parse(
                                  Platform.isAndroid
                                      ? "https://play.google.com/store/apps/details?id=com.buson.verifytapp"
                                      : "https://apps.apple.com/app/id$appId",
                                );
                                launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                ).then((value) {
                                  // exit(0);
                                });
                              }
                            },
                            child: Text(
                              'Update',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        width: Screens.width(context) * 0.25,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop('Close');
                            },
                            child: Text(
                              'Close',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
