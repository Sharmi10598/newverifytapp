import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:verifytapp/Constant/Screen.dart';
import 'package:verifytapp/Controllers/AuditController/AuditControllers.dart';
import '../../Controllers/ConfigPageController/ConfigScreenController.dart';
import '../../Controllers/DashBoardController/DashBoradControllers.dart';
import '../../DBHelper/DBHelpers.dart';
import '../../driftDB/driftTablecreation.dart';
import '../../driftDB/driftoperation.dart';
import '../QrScannerPage/QrPage.dart';
import 'BinDetailTable.dart';

class ItemDetails extends StatefulWidget {
  ItemDetails({super.key, required this.title, required this.theme});
  String title;
  ThemeData theme;
  @override
  State<ItemDetails> createState() => ItemDetailsState();
}

class ItemDetailsState extends State<ItemDetails> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context
        .read<AuditCtrlProvider>()
        .callTimeEnableMethod(context, widget.theme);
          context
                                          .read<AuditCtrlProvider>()
                                          . getitemcodeforsuggestion();
    context.read<AuditCtrlProvider>().nextdisable = false;
    context.read<AuditCtrlProvider>().scandata = [];
    // context.read<AuditCtrlProvider>().scantotaldeviceqty();

    if (context.read<AuditCtrlProvider>().mycontroller[2].text.isNotEmpty) {
      context.read<AuditCtrlProvider>().binTableDetails(
          context.read<AuditCtrlProvider>().mycontroller[2].text);
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  DateTime? lastInputTime;
  //   void onTextChanged(String value) {
  //   final provider = context.read<AuditCtrlProvider>();
  //   DateTime now = DateTime.now();

  //   if (lastInputTime != null) {
  //     Duration difference = now.difference(lastInputTime!);
  //     bool isScanned = difference.inMilliseconds < 50; // Scanned input is very fast

  //     log("Time Diff: ${difference.inMilliseconds}ms | Is Scanned: $isScanned");

  //     provider.setManualType(!isScanned);
  //   }

  //   lastInputTime = now;
  // }
int lastLength = 0;
  void onTextChanged(String value) {
    DateTime now = DateTime.now();
    if (lastInputTime != null) {
      Duration difference = now.difference(lastInputTime!);
      
       bool isScanned = (value.length > lastLength + 3) || (difference.inMilliseconds < 50);

      if (isScanned) {
        log("Detected SCAN input");
        context.read<AuditCtrlProvider>().setManualType(false);
      } else {
        log("Detected MANUAL input");
        context.read<AuditCtrlProvider>().setManualType(true);
      }
    }

    lastInputTime = now;
    lastLength = value.length;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: Screens.padingHeight(context),
            padding: EdgeInsets.only(
              top: Screens.padingHeight(context) * 0.015,
              right: Screens.width(context) * 0.03,
              left: Screens.width(context) * 0.03,
              bottom: Screens.padingHeight(context) * 0.015,
            ),
            color: Colors.grey[300],
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(
                      top: Screens.padingHeight(context) * 0.01,
                      bottom: Screens.padingHeight(context) * 0.01),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Database db = (await DBHelper.getInstance())!;
                          // DBOperation.truncateScanpostDataT(db);
                          // DBOperation.truncateCheckListT(db);
                        },
                        child: Text(
                            'Total Items Audited - ${context.watch<AuditCtrlProvider>().fetchAuditForDetails!.totalItems ?? 0}',
                            style: widget.theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: Screens.padingHeight(context) * 0.01),
                          child: const Divider(
                            thickness: 1.5,
                          )),
                      Text(
                          'Total Quantities Scanned - ${context.watch<AuditCtrlProvider>().fetchAuditForDetails!.unitsScanned ?? 0}',
                          style: widget.theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Container(
                          padding: EdgeInsets.only(
                              left: Screens.padingHeight(context) * 0.01),
                          child: const Divider(
                            thickness: 1.5,
                          )),
                      Text(
                          'Total Scanned Count / Qty - ${context.read<AuditCtrlProvider>().totalscandevicecount ?? 0}/ ${context.watch<AuditCtrlProvider>().totalscandeviceQty ?? 0}',
                          style: widget.theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 15))
                    ],
                  ),
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.02,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // context
                        //     .read<AuditCtrlProvider>()
                        //     .checkListformCreation(context, theme, 2);
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        // color: Colors.green,
                        width: Screens.padingHeight(context) * 0.3,
                        child: Text('Scan the Items',
                            style: widget.theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            foregroundColor: Colors.white,
                            backgroundColor: widget.theme.primaryColor),
                        onPressed: () {
                          context.read<AuditCtrlProvider>().clearbtn();
                        },
                        child: const Text("Clear"))
                  ],
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.015,
                ),
                Form(
                  key: context.watch<AuditCtrlProvider>().formkey2,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: TextFormField(
                          onChanged: (value) {},
                          controller: context
                              .watch<AuditCtrlProvider>()
                              .mycontroller[2],
                          // autofocus: true,
                          focusNode: context.watch<AuditCtrlProvider>().focus1,
                          autofocus: context
                                  .read<AuditCtrlProvider>()
                                  .mycontroller[2]
                                  .text
                                  .isNotEmpty
                              ? false
                              : true,

                          onEditingComplete: () {
                            context.read<AuditCtrlProvider>().afterScanbinCode(
                                context,
                                widget.theme,
                                'BinCode',
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[2]
                                    .text);

                            if (context
                                .read<AuditCtrlProvider>()
                                .mycontroller[2]
                                .text
                                .isNotEmpty) {
                              context.read<AuditCtrlProvider>().binTableDetails(
                                  context
                                      .read<AuditCtrlProvider>()
                                      .mycontroller[2]
                                      .text);

                              context
                                  .read<AuditCtrlProvider>()
                                  .focus2
                                  .requestFocus();
                            } else {}
                          },
                          onTap: () {
                            context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[2]
                                    .text =
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[2]
                                    .text;
                            context
                                .read<AuditCtrlProvider>()
                                .mycontroller[2]
                                .selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: context
                                  .read<AuditCtrlProvider>()
                                  .mycontroller[2]
                                  .text
                                  .length,
                            );
                          },
                          // textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '*Scan Bin';
                            } else if (value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: ConfigController.isScanner == true
                                ? null
                                : IconButton(
                                    onPressed: () async {
                                      final database =
                                          (await AppDatabase.initialize())!;

                                      Database db =
                                          (await DBHelper.getInstance())!;
                                      await driftoperation
                                          .getallLineColumnproduct(database);
                                      if (context
                                              .read<AuditCtrlProvider>()
                                              .networkTimeStatus ==
                                          'Enabled') {
                                        ScannerPageState.bincodeScan = true;
                                        context
                                            .read<AuditCtrlProvider>()
                                            .mycontroller[4]
                                            .text = '';
                                        context
                                            .read<AuditCtrlProvider>()
                                            .mycontroller[3]
                                            .text = '';

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ScannerPage()));
                                      } else {
                                        context
                                            .read<AuditCtrlProvider>()
                                            .callTimeEnableMethod(
                                                context, widget.theme);
                                      }
                                    },
                                    icon: const Icon(Icons.qr_code_2_sharp)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Screens.width(context) * 0.03,
                                vertical: Screens.fullHeight(context) * 0.01),
                            labelText: 'Scan Bin',
                            labelStyle: widget.theme.textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey),
                            focusedBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(25),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            errorBorder: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.01,
                ),
                Container(
                  color: context
                          .watch<AuditCtrlProvider>()
                          .mycontroller[2]
                          .text
                          .isNotEmpty
                      ? Colors.white
                      : Colors.grey[300],
                  alignment: Alignment.center,
                  child: TextFormField(
                    autofocus: true,
                    onFieldSubmitted:(v){
                      log("AKLLALA::"+v.toString());

                    },
                    focusNode: context.watch<AuditCtrlProvider>().focus2,
                    readOnly: context
                            .watch<AuditCtrlProvider>()
                            .mycontroller[2]
                            .text
                            .isNotEmpty
                        ? false
                        : true,
                    controller:
                        context.watch<AuditCtrlProvider>().mycontroller[3],
                    onChanged: (value) {
                      log("hhhhhh"+context
                          .read<AuditCtrlProvider>()
                          .mycontroller[3]
                          .text);
                      // if (context
                      //     .read<AuditCtrlProvider>()
                      //     .mycontroller[2]
                      //     .text
                      //     .isNotEmpty) {
                      //   context.read<AuditCtrlProvider>().afterScanbinCode(
                      //       context,
                      //       widget.theme,
                      //       'BinCode',
                      //       context
                      //           .read<AuditCtrlProvider>()
                      //           .mycontroller[2]
                      //           .text);

                      // context.read<AuditCtrlProvider>().afterScanbinCode2(
                      //     context,
                      //     widget.theme,
                      //     'BinCode',
                      //     context
                      //         .read<AuditCtrlProvider>()
                      //         .mycontroller[2]
                      //         .text);
                      // }

                      if (context
                          .read<AuditCtrlProvider>()
                          .mycontroller[3]
                          .text
                          .isEmpty) {
                        context.read<AuditCtrlProvider>().mycontroller[4].text =
                            '';
                        context.read<AuditCtrlProvider>().mycontroller[5].text =
                            '';
                      }
    //                   if (context
    //                       .read<AuditCtrlProvider>()
    //                       .mycontroller[3]
    //                       .text
    //                       .isNotEmpty && (context
    //                       .read<AuditCtrlProvider>()
    //                       .mycontroller[3]
    //                       .text
    //                       .endsWith("\n") || context
    //                       .read<AuditCtrlProvider>()
    //                       .mycontroller[3]
    //                       .text.endsWith("\t"))) {
    // context
    //                       .read<AuditCtrlProvider>()
    //                       .setManualType(false);
    //   log("Confirmed SCANNED on EditComplete");
    // }else{
    //     log("Confirmed SCANNED on Manualenter");
    // }
                      onTextChanged(value);
                      // context.read<AuditCtrlProvider>().isManualtype = true;
                    },
                    onEditingComplete: () async {
                      
                       log("hiiii"+context.read<AuditCtrlProvider>().isManualtype.toString());
                      context.read<AuditCtrlProvider>().filenamedet = [];
                      setState(() {
                        if (context
                            .read<AuditCtrlProvider>()
                            .formkey2
                            .currentState!
                            .validate()) {
                          if (context
                              .read<AuditCtrlProvider>()
                              .mycontroller[3]
                              .text
                              .isNotEmpty) {
                            context
                                .read<AuditCtrlProvider>()
                                .groupValueSelected = 0;

                            context.read<AuditCtrlProvider>().focus2.unfocus();
                            

                            context.read<AuditCtrlProvider>().checkAlreadyItem(
                                context,
                                widget.theme,
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[3]
                                    .text,
                                int.parse(context
                                    .read<AuditCtrlProvider>()
                                    .fetchAuditForDetails!
                                    .docEntry
                                    .toString()),context
                                    .read<AuditCtrlProvider>()
                                    .formkey3);
                            // context
                            //     .read<AuditCtrlProvider>()
                            //     .afterScanSerialBatch(
                            //       context,
                            //       widget.theme,
                            //       context
                            //           .read<AuditCtrlProvider>()
                            //           .mycontroller[3]
                            //           .text,
                            //     );
                          }
                        }
                      });

                      context
                          .read<AuditCtrlProvider>()
                          .mycontroller[3]
                          .selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: context
                            .read<AuditCtrlProvider>()
                            .mycontroller[3]
                            .text
                            .length,
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Scan Serial Batch';
                      }
                      return null;
                    },
                    onTap: () {
                      context.read<AuditCtrlProvider>().mycontroller[3].text =
                          context
                              .read<AuditCtrlProvider>()
                              .mycontroller[3]
                              .text;
                      context
                          .read<AuditCtrlProvider>()
                          .mycontroller[3]
                          .selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: context
                            .read<AuditCtrlProvider>()
                            .mycontroller[3]
                            .text
                            .length,
                      );
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      suffixIcon: ConfigController.isScanner == true
                          ? null
                          : IconButton(
                              onPressed: () {
                                if (context
                                        .read<AuditCtrlProvider>()
                                        .networkTimeStatus ==
                                    'Enabled') {
                                  // if (context
                                  //     .read<AuditCtrlProvider>()
                                  //     .mycontroller[2]
                                  //     .text
                                  //     .isNotEmpty) {
                                  //   context
                                  //       .read<AuditCtrlProvider>()
                                  //       .afterScanbinCode(
                                  //           context,
                                  //           widget.theme,
                                  //           'BinCode',
                                  //           context
                                  //               .read<AuditCtrlProvider>()
                                  //               .mycontroller[2]
                                  //               .text);
                                  // }

                                  // if (context
                                  //         .read<AuditCtrlProvider>()
                                  //         .invalidBin ==
                                  //     false) {
                                  if (context
                                      .read<AuditCtrlProvider>()
                                      .formkey2
                                      .currentState!
                                      .validate()) {
                                    ScannerPageState.batchCodeScan = true;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ScannerPage()));
                                  }
                                  // }
                                } else {
                                  context
                                      .read<AuditCtrlProvider>()
                                      .callTimeEnableMethod(
                                          context, widget.theme);
                                }
                              },
                              icon: const Icon(Icons.qr_code_2_sharp)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Screens.width(context) * 0.03,
                          vertical: Screens.fullHeight(context) * 0.01),
                      labelText: 'Scan Serial Batch',
                      labelStyle: widget.theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.grey),
                      focusedBorder: const OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(width: 1, color: Colors.grey),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: const OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.01,
                ),
                context
                            .watch<AuditCtrlProvider>()
                            .mycontroller[2]
                            .text
                            .isNotEmpty &&
                        context.watch<AuditCtrlProvider>().binDetails.isNotEmpty
                    ? Container(
                        color: Colors.white,
                        child: BinDetailstable(
                          tablerColumn:
                              context.watch<AuditCtrlProvider>().binDetails,
                        ))
                    : Container()
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_comment_rounded),
                label: 'Audit',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                label: 'Data',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Config',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(
                  AssetImage('assets/power-button.png'),
                  size: 20,
                ),
                label: 'Logout',
              ),
            ],
            currentIndex: context.read<DashBoardCtrlProvider>().selectedIndex,
            selectedItemColor: const Color(0xFF009292),
            unselectedItemColor: Colors.grey,
            selectedIconTheme: const IconThemeData(
              color: Color(0xFF009292),
            ),
            showUnselectedLabels: true,
            onTap: context.read<DashBoardCtrlProvider>().selectedIndex == 5
                ? context.read<DashBoardCtrlProvider>().onLogoutTapped
                : context.read<DashBoardCtrlProvider>().onItemDetTapped,
          ),
        ));
  }
}
