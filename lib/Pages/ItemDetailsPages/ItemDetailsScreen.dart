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
  ItemDetails({super.key, required this.title});
  String title;
  @override
  State<ItemDetails> createState() => ItemDetailsState();
}

class ItemDetailsState extends State<ItemDetails> with WidgetsBindingObserver {
  bool bincodeScan = false;
  bool batchCodeScan = false;
  bool itemCodeScan = false;
  bool bincode = false;
  bool disputeval = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<AuditCtrlProvider>().callTimeEnableMethod(context);
    context.read<AuditCtrlProvider>().nextdisable = false;
    context.read<AuditCtrlProvider>().scandata = [];
    context.read<AuditCtrlProvider>().scantotaldeviceqty();

    if (context.read<AuditCtrlProvider>().mycontroller[2].text.isNotEmpty) {
      context.read<AuditCtrlProvider>().binTableDetails(
          context.read<AuditCtrlProvider>().mycontroller[2].text);
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                            'Total Items Audited - ${context.watch<AuditCtrlProvider>().fetchAuditForDetails.totalItems ?? 0}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              left: Screens.padingHeight(context) * 0.01),
                          child: const Divider(
                            thickness: 1.5,
                          )),
                      Text(
                          'Total Quantities Scanned - ${context.watch<AuditCtrlProvider>().fetchAuditForDetails.unitsScanned ?? 0}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      Container(
                          padding: EdgeInsets.only(
                              left: Screens.padingHeight(context) * 0.01),
                          child: const Divider(
                            thickness: 1.5,
                          )),
                      Text(
                          'Total Scanned Count / Qty - ${context.watch<AuditCtrlProvider>().totalscandevicecount ?? 0}/ ${context.watch<AuditCtrlProvider>().totalscandeviceQty ?? 0}',
                          style: theme.textTheme.bodyLarge?.copyWith(
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
                            style: theme.textTheme.bodyLarge?.copyWith(
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
                            backgroundColor: theme.primaryColor),
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
                  key: context.watch<AuditCtrlProvider>().formkey[2],
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: TextFormField(
                          onChanged: (value) {
                            // setState(() {
                            //   context
                            //       .read<AuditCtrlProvider>()
                            //       .checkCtrlFocus();
                            // });
                          },
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
                                theme,
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
                            } else {
                              // focus1.requestFocus();
                              // focus2.unfocus();
                            }
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
                                            .callTimeEnableMethod(context);
                                      }
                                    },
                                    icon: const Icon(Icons.qr_code_2_sharp)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Screens.width(context) * 0.03,
                                vertical: Screens.fullHeight(context) * 0.01),
                            labelText: 'Scan Bin',
                            labelStyle: theme.textTheme.bodyLarge
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
                      context.read<AuditCtrlProvider>().isManualtype = true;
                    },
                    onEditingComplete: () async {
                      setState(() {
                        if (context
                            .read<AuditCtrlProvider>()
                            .formkey[2]
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

                            context
                                .read<AuditCtrlProvider>()
                                .afterScanSerialBatch(
                                  context,
                                  theme,
                                  context
                                      .read<AuditCtrlProvider>()
                                      .mycontroller[3]
                                      .text,
                                );
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
                                  if (context
                                      .read<AuditCtrlProvider>()
                                      .formkey[2]
                                      .currentState!
                                      .validate()) {
                                    ScannerPageState.batchCodeScan = true;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ScannerPage()));
                                  }
                                } else {
                                  context
                                      .read<AuditCtrlProvider>()
                                      .callTimeEnableMethod(context);
                                }
                              },
                              icon: const Icon(Icons.qr_code_2_sharp)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Screens.width(context) * 0.03,
                          vertical: Screens.fullHeight(context) * 0.01),
                      labelText: 'Scan Serial Batch',
                      labelStyle: theme.textTheme.bodyLarge
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
                icon: ImageIcon(AssetImage('assets/power-button.png')),
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
// linemaster limitresult::S00001-3:BUSON1::001@:: B011
// [log] linemaster limitresult::S00002DRESSINGTABLE-3:BUSON2::002 DRESSING TABLE:: B04
// [log] linemaster limitresult::S00006SILDUMMY-3:BUSON3::006 SIL dummy:: B015
// [log] linemaster limitresult::S00006SILDUMMYITEM-3:BUSON4::006 SIL dummy item:: B02
// [log] linemaster limitresult::S00006SILDUMMYITEM10-3:BUSON5::006 SIL dummy item10:: B09
// [log] linemaster limitresult::S00006SILDUMMYITEM11-3:BUSON::006 SIL dummy item11:: B014
// [log] linemaster limitresult::S00006SILDUMMYITEM12-3:::006 SIL dummy item12:: B013
// [log] linemaster limitresult::S00006SILDUMMYITEM120-3:::006 SIL dummy item120:: B020
// [log] linemaster limitresult::S00006SILDUMMYITEM13-3:::006 SIL dummy item13:: B019
// [log] linemaster limitresult::S00006SILDUMMYITEM14-3:::006 SIL dummy item14:: B02