import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Controllers/AuditController/AuditControllers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:verifytapp/Pages/AuditPages/Widgets/ErrorTable.dart';
import 'package:verifytapp/Pages/AuditPages/Widgets/SuccessTable.dart';
import 'package:verifytapp/Pages/ItemDetailsPages/ItemDetailsScreen.dart';
import 'package:verifytapp/Pages/QrScannerPage/QrPage.dart';
import '../../../Constant/Configuration.dart';
import '../../../Constant/Screen.dart';
import '../../../Services/GetAuditApi/SyncExternalStockSnapApi.dart';
import '../../../driftDB/driftTablecreation.dart';
import '../../../driftDB/driftoperation.dart';
import '../../ScanSearchScreens/ScanLogSearchPage.dart';
import 'MainTables.dart';

class AuditingOpenScreen extends StatefulWidget {
  const AuditingOpenScreen({super.key});

  @override
  State<AuditingOpenScreen> createState() => _AuditingOpenScreenState();
}

class _AuditingOpenScreenState extends State<AuditingOpenScreen> {
  Config config = Config();

  // @override
  // void dispose() {
  //   context.read<AuditCtrlProvider>().audioPlayer?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
        child: Container(
      padding: EdgeInsets.only(
          left: Screens.width(context) * 0.02,
          right: Screens.width(context) * 0.02),
      color: Colors.grey[200],
      child: RefreshIndicator(
        onRefresh: () {
          return context
              .read<AuditCtrlProvider>()
              .callAuditapiwhilenetoff(context, theme);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: Screens.padingHeight(context) * 0.07,
                ),
                height: Screens.padingHeight(context) * 0.825,
                child: context.watch<AuditCtrlProvider>().isLoading == true &&
                        context.watch<AuditCtrlProvider>().errorMsg.isEmpty &&
                        context.watch<AuditCtrlProvider>().openAuditList.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: theme.primaryColor,
                        ),
                      )
                    // : context.watch<AuditCtrlProvider>().isLoading == false &&
                    // context
                    //     .watch<AuditCtrlProvider>()
                    //     .errorMsg
                    //     .isNotEmpty &&

                    // context.watch<AuditCtrlProvider>().isLoading == true &&
                    //         context
                    //             .watch<AuditCtrlProvider>()
                    //             .openAuditList
                    //             .isEmpty
                    //     ? Center(
                    //         child: CircularProgressIndicator(
                    //           color: theme.primaryColor,
                    //         ),
                    //       )
                    //     :
//No Audit Data
                    : context.watch<AuditCtrlProvider>().isLoading == false &&
                            context
                                .watch<AuditCtrlProvider>()
                                .openAuditList
                                .isEmpty &&
                            context
                                .watch<AuditCtrlProvider>()
                                .errorMsg
                                .isNotEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: Screens.padingHeight(context) * 0.15,
                                  width: Screens.width(context) * 0.5,
                                  child: Image(
                                      image: AssetImage('assets/no-data.png')),
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Text(
                                  'No data',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(0),
                            itemCount: context
                                .watch<AuditCtrlProvider>()
                                .openAuditList
                                .length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0,
                                child: GestureDetector(
                                  onDoubleTap: () async {
                                    context
                                        .read<AuditCtrlProvider>()
                                        .fetchAuditForDetails = null;

                                    context
                                        .read<AuditCtrlProvider>()
                                        .selectItemColor = false;

                                    log('docEntrydocEntry:::${context.read<AuditCtrlProvider>().openAuditList[index].docEntry}');
                                    await context
                                        .read<AuditCtrlProvider>()
                                        .fetchOpenDetails(
                                            context
                                                .read<AuditCtrlProvider>()
                                                .openAuditList[index],
                                            index);

                                    ScannerPageState.bincodeScan = false;
                                    ScannerPageState.batchCodeScan = false;
                                    ScannerPageState.searchScan = false;
                                    await context
                                        .read<AuditCtrlProvider>()
                                        .callGetuserDetailsnApi(
                                          context
                                              .read<AuditCtrlProvider>()
                                              .openAuditList[index]
                                              .docEntry,
                                          context,
                                          theme,
                                        );

                                    log('fetchAuditForDetails!.docEntry.toString()::${context.read<AuditCtrlProvider>().fetchAuditForDetails!.docEntry.toString()}');
                                    await context
                                        .read<AuditCtrlProvider>()
                                        .scantotaldeviceqty();
                                    await context
                                        .read<AuditCtrlProvider>()
                                        .selectColor(
                                            index,
                                            context
                                                .read<AuditCtrlProvider>()
                                                .fetchAuditForDetails!
                                                .docEntry!);
                                    if (context
                                            .read<AuditCtrlProvider>()
                                            .openAuditList[index]
                                            .status ==
                                        'In-Process') {
                                      context
                                          .read<AuditCtrlProvider>()
                                          .resetaudit = false;
                                         

                                      await context
                                          .read<AuditCtrlProvider>()
                                          .getTotalLengthItems(context
                                              .read<AuditCtrlProvider>()
                                              .openAuditList[index]
                                              .docEntry);
                                      await callStockSnapApi(
                                          context,
                                          theme,
                                          context
                                              .read<AuditCtrlProvider>()
                                              .openAuditList[index]
                                              .docEntry,
                                          index);
                                    } else if (context
                                            .read<AuditCtrlProvider>()
                                            .openAuditList[index]
                                            .status ==
                                        'Open') {
                                      context
                                          .read<AuditCtrlProvider>()
                                          .openStatusAlertBox(theme, context);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: context
                                                        .watch<
                                                            AuditCtrlProvider>()
                                                        .openAuditList[index]
                                                        .selectListcolor ==
                                                    true
                                                ? theme.primaryColor
                                                : Colors.black26)),
                                    padding: EdgeInsets.all(
                                        Screens.padingHeight(context) * 0.008),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.53,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  context
                                                      .watch<
                                                          AuditCtrlProvider>()
                                                      .openAuditList[index]
                                                      .scheduleName,
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(
                                                  'Scheduled at ${config.alignDate(context.watch<AuditCtrlProvider>().openAuditList[index].auditFrom)}',
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.grey)),
                                              Text(
                                                  'Location : ${context.watch<AuditCtrlProvider>().openAuditList[index].whsCode}',
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: Screens.width(context) * 0.25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                context
                                                        .watch<
                                                            AuditCtrlProvider>()
                                                        .openAuditList[index]
                                                        .percent
                                                        .toString() +
                                                    "%",
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.cyan,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                              context
                                                          .watch<
                                                              AuditCtrlProvider>()
                                                          .openAuditList[index]
                                                          .isStarting ==
                                                      false
                                                  ? Text(
                                                      context
                                                          .watch<
                                                              AuditCtrlProvider>()
                                                          .openAuditList[index]
                                                          .status,
                                                      style: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              color: context
                                                                          .watch<
                                                                              AuditCtrlProvider>()
                                                                          .openAuditList[
                                                                              index]
                                                                          .status ==
                                                                      'Re-Audit'
                                                                  ? Colors.red
                                                                  : Colors.cyan,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    )
                                                  : Container(
                                                      width: Screens.width(
                                                          context),
                                                      // height:
                                                      //     Screens.pad(context),
                                                      color: Colors.white60,
                                                      child: Center(
                                                        child:
                                                            SpinKitThreeBounce(
                                                          size: Screens
                                                                  .padingHeight(
                                                                      context) *
                                                              0.03,
                                                          color: theme
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                              Text(
                                                context
                                                    .watch<AuditCtrlProvider>()
                                                    .openAuditList[index]
                                                    .unitsScanned
                                                    .toString(),
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                        color: context
                                                                    .watch<
                                                                        AuditCtrlProvider>()
                                                                    .openAuditList[
                                                                        index]
                                                                    .status ==
                                                                'Re-Audit'
                                                            ? Colors.red
                                                            : Colors.cyan,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.05,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  showViewDetailsDialog(BuildContext context, ThemeData theme) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                content: context
                    .watch<AuditCtrlProvider>()
                    .auditDetailsDialog(context, theme));
          });
        });
  }

  dataLogsDetailsDialog(BuildContext context, ThemeData theme, int docEntry) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, st) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.all(8),
            content: Container(
              width: Screens.width(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: Screens.width(context) * 0.1,
                        right: Screens.width(context) * 0.03),
                    color: theme.primaryColor,
                    // width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: Screens.width(context) * 0.15,
                              right: Screens.width(context) * 0.0),
                          height: Screens.bodyheight(context) * 0.06,
                          alignment: Alignment.center,
                          child: Text("View Downloaded Logs",
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.2,
                    padding: EdgeInsets.only(
                      top: Screens.bodyheight(context) * 0.01,
                      bottom: Screens.bodyheight(context) * 0.01,
                      left: Screens.width(context) * 0.03,
                      right: Screens.width(context) * 0.03,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: Screens.padingHeight(context) * 0.01,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: Screens.width(context) * 0.7,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Stock Records : ${context.watch<AuditCtrlProvider>().stockRecord}',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(),
                                      ),
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.01,
                                      ),
                                      Text(
                                        'Total Item Records : ${context.watch<AuditCtrlProvider>().itemMasterRecord}',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(),
                                      ),
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.01,
                                      ),
                                      Text(
                                        'Total Bin Records   : ${context.watch<AuditCtrlProvider>().binRecord}',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(),
                                      ),
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.01,
                                      ),
                                      Text(
                                        'Last Downloaded Time Stamp  : ${context.watch<AuditCtrlProvider>().lastDocTimeSStamp != null ? context.watch<AuditCtrlProvider>().lastDocTimeSStamp : ''}',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.06,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          // context.read<OrderTabController>().viweDetailsClicked();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: theme.primaryColor,
                          textStyle: const TextStyle(
                              // fontSize: 12,
                              ),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )), //Radius.circular(6)
                        ),
                        child: const Text("Close")),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  callStockSnapApi(
      BuildContext context, ThemeData theme, int docEntry, int index) {
    SyncExternalStockApi.getData(
            context.read<AuditCtrlProvider>().fetchAuditForDetails!.whsCode!)
        .then((value) {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
      } else {}
    });
    log('openAuditList[index].selectListcolor222::${context.read<AuditCtrlProvider>().openAuditList[index].selectListcolor}');

    showOpenDialog(context, theme, docEntry, index);
  }

  showOpenDialog(
      BuildContext context, ThemeData theme, int docEntry, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                contentPadding: EdgeInsets.zero,
                content: onTapOpenDialog(context, theme, docEntry, index));
          });
        });
  }

  Container onTapOpenDialog(
      BuildContext context, ThemeData theme, int docEntry, int index) {
    return Container(
      padding: EdgeInsets.zero,
      width: Screens.width(context),
      //  height: Screens.bodyheight(context)*0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: Screens.padingHeight(context) * 0.06),
                  // color: Colors.green,
                  width: Screens.width(context) * 0.8,
                  child: Center(
                      child: Text("Action",
                          style: theme.textTheme.bodyLarge!
                              .copyWith(color: Colors.white))),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                      context.read<AuditCtrlProvider>().selectItemColor = false;
                      log('openAuditList[index].selectListcolor::${context.read<AuditCtrlProvider>().openAuditList[index].selectListcolor}');
                    },
                    icon: const Icon(Icons.close, color: Colors.white))
              ],
            ),
          ),
          Container(
            width: Screens.width(context),
            padding: EdgeInsets.only(
              left: Screens.width(context) * 0.03,
              right: Screens.width(context) * 0.03,
              top: Screens.bodyheight(context) * 0.01,
              bottom: Screens.bodyheight(context) * 0.01,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: Screens.bodyheight(context) * 0.02,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          width: Screens.width(context) * 0.4,
                          //  height: Screens.padingHeight(context)*0.2,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<AuditCtrlProvider>().resetaudit =
                                  true;
                              context.read<AuditCtrlProvider>().isClickedStart =
                                  false;

                              String mssgg =
                                  "Already this audit related data are available in memory. \nClick 'Continue' to proceed with this data or 'Reset' to start a new process.";

                              context.read<AuditCtrlProvider>().checkTableEmpty(
                                  context, theme, mssgg, '', docEntry, index);
                              // checktimediv(
                              //     context, theme, mssgg, '', docEntry, index);
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: theme.primaryColor
                                // Colors.grey[200]
                                ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.download_outlined,
                                        size: 30,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Container(
                                  child: Text("Download Data",
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                            onPressed: () async {
                              final database =
                                  (await AppDatabase.initialize())!;

                              context.read<AuditCtrlProvider>().clearbtn();
                              context
                                  .read<AuditCtrlProvider>()
                                  .mycontroller[5]
                                  .text = '';
                              context
                                  .read<AuditCtrlProvider>()
                                  .mycontroller[4]
                                  .text = '';
                              context.read<AuditCtrlProvider>().incQty = 0;
                              context
                                      .read<AuditCtrlProvider>()
                                      .getItemCodedocentryResult =
                                  await driftoperation.getItemCodeMasterdata(
                                      database,
                                      int.parse(context
                                          .read<AuditCtrlProvider>()
                                          .fetchAuditForDetails!
                                          .docEntry
                                          .toString()));

                              context
                                  .read<AuditCtrlProvider>()
                                  .callGetBinNumApi(
                                      context
                                          .read<AuditCtrlProvider>()
                                          .openAuditList[index]
                                          .docEntry,
                                      context,
                                      theme);

                              if (context
                                  .read<AuditCtrlProvider>()
                                  .getItemCodedocentryResult
                                  .isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemDetails(
                                              title:
                                                  '#${context.read<AuditCtrlProvider>().openAuditList[index].docNum} - ${context.read<AuditCtrlProvider>().openAuditList[index].scheduleName}',
                                              theme: theme,
                                            )));
                              } else {
                                context
                                    .read<AuditCtrlProvider>()
                                    .downloadDataAlertBox(theme, context);
                              }
                              // context
                              //     .read<AuditCtrlProvider>()
                              //     .isClickedStart = false;

                              // if (context
                              //         .read<AuditCtrlProvider>()
                              //         .fetchAuditForDetails
                              //         .status ==
                              //     'In-Process') {
                              //   context
                              //       .read<AuditCtrlProvider>()
                              //       .isClickedStart = false;

                              //   String mssgg =
                              //       "Starting Stock Audits takes some time";
                              //   context
                              //       .read<AuditCtrlProvider>()
                              //       .checktimediv(context, theme, mssgg,
                              //           'Get', docEntry, index);
                              //   // context
                              //   //     .read<AuditCtrlProvider>()
                              //   // .callGetAuditActionApi(context, theme,
                              //   //     'Get', docEntry, index);
                              //   // context
                              //   //     .read<AuditCtrlProvider>()
                              //   //     .callGetAuditApi(context, theme);
                              //   }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: theme.primaryColor
                                // Colors.grey[200]
                                ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.document_scanner_rounded,
                                        size: 30,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.zero,
                                  child: Text("Scan Now",
                                      textAlign: TextAlign.left,
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: Screens.padingHeight(context) * 0.01,
                    ),

                    //secode Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              if (context
                                      .read<AuditCtrlProvider>()
                                      .usetDetailData[0]
                                      .auditRole ==
                                  'Owner') {
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[0]
                                    .text = '';
                                context
                                    .read<AuditCtrlProvider>()
                                    .showRescheduleDialog(
                                        context, theme, docEntry);
                              } else {
                                String msgg =
                                    'You are not authorized to reschedule';
                                context
                                    .read<AuditCtrlProvider>()
                                    .RescheduleAbortAlertBox(
                                        context, theme, msgg);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: theme.primaryColor
                                // Colors.grey[200]
                                ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.edit_square,
                                        size: 30,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    "Reschedule",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //invoice
                        SizedBox(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              if (context
                                      .read<AuditCtrlProvider>()
                                      .usetDetailData[0]
                                      .auditRole ==
                                  'Owner') {
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[1]
                                    .text = '';
                                context
                                    .read<AuditCtrlProvider>()
                                    .showAbortDialog(context, theme, docEntry);
                              } else {
                                String msgg1 =
                                    'You are not authorized to abort the audit';
                                context
                                    .read<AuditCtrlProvider>()
                                    .RescheduleAbortAlertBox(
                                        context, theme, msgg1);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: theme.primaryColor
                                // Colors.grey[200]
                                ),
                            //
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.cancel_presentation,
                                        size: 30,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    "Abort",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanLogsSearch(
                                          docEntry: context
                                              .read<AuditCtrlProvider>()
                                              .fetchAuditForDetails!
                                              .docEntry
                                              .toString())));
                              // setState(() {
                              //   for (var i = 0;
                              //       i <
                              //           context
                              //               .read<AuditCtrlProvider>()
                              //               .viewLoadDetails
                              //               .length;
                              //       i++) {
                              //     if (context
                              //             .read<AuditCtrlProvider>()
                              //             .viewLoadDetails[i]
                              //             .docEntry ==
                              //         docEntry) {
                              //       context
                              //               .read<AuditCtrlProvider>()
                              //               .lastDocTimeSStamp =
                              //           context
                              //               .read<AuditCtrlProvider>()
                              //               .viewLoadDetails[i]
                              //               .lasttimestamp
                              //               .toString();
                              //     }
                              //   }
                              //   dataLogsDetailsDialog(context, theme, docEntry);
                              // });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: theme.primaryColor
                                // Colors.grey[200]
                                ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.search_outlined,
                                        size: 33,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    "Search",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<AuditCtrlProvider>()
                                  .groupScanlogValueSelected = 0;
                              context
                                  .read<AuditCtrlProvider>()
                                  .getScannedInformation(docEntry);
                              scanLogsDetailsDialog(context, theme);
                              context
                                      .read<AuditCtrlProvider>()
                                      .groupScanlogValueSelected ==
                                  0;
                              context.read<AuditCtrlProvider>().syncdatafreeze =
                                  false;
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size.zero, // Set this
                                padding: EdgeInsets.zero, // and this
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: theme.primaryColor
                                // Colors.grey[200]
                                ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Icon(
                                        Icons.domain,
                                        size: 33,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.01,
                                ),
                                Container(
                                  child: Text(
                                    "Scan Logs",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Screens.bodyheight(context) * 0.02,
          ),
          Container(
            width: Screens.width(context),
            height: Screens.bodyheight(context) * 0.06,
            child: ElevatedButton(
                onPressed: () async {
                  showViewDetailsDialog(context, theme);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )),
                ),
                child: const Text("View Details")),
          ),
        ],
      ),
    );
  }

  scanLogsDetailsDialog(BuildContext context, ThemeData theme) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, st) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            content: Container(
              width: Screens.width(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: Screens.width(context) * 0.1,
                        right: Screens.width(context) * 0.03),
                    color: theme.primaryColor,
                    // width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Screens.width(context) * 0.7,
                          alignment: Alignment.center,
                          child: Text("Scan Log Details",
                              style: theme.textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white)),
                        ),
                        InkWell(
                          onTap: () {
                            st(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                          child: Container(
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.77,
                    padding: EdgeInsets.only(
                      top: Screens.bodyheight(context) * 0.01,
                      bottom: Screens.bodyheight(context) * 0.01,
                      left: Screens.width(context) * 0.03,
                      right: Screens.width(context) * 0.03,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: Screens.padingHeight(context) * 0.01,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // width: Screens.width(context) * 0.5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Scanned Records : ${context.watch<AuditCtrlProvider>().totalScan} ',
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: Screens.padingHeight(context) *
                                            0.01,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: Screens.width(context) * 0.3,
                                            child: Text('Pushed to Server'),
                                          ),
                                          Text(
                                              ': ${context.watch<AuditCtrlProvider>().totalSuccess} '),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: Screens.width(context) * 0.3,
                                            child: Text('Errors in Sync'),
                                          ),
                                          Text(
                                              ': ${context.watch<AuditCtrlProvider>().totalError} '),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: Screens.width(context) * 0.3,
                                            child: Text('Audit Id'),
                                          ),
                                          Text(
                                              ': ${context.watch<AuditCtrlProvider>().fetchAuditForDetails!.docEntry}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: Screens.width(context) * 0.3,
                                            child: Text('Device Id'),
                                          ),
                                          Text(
                                              ': ${context.watch<AuditCtrlProvider>().deviceId}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: Screens.width(context) * 0.3,
                                            child: Text('Whs Code '),
                                          ),
                                          Text(
                                              ': ${context.watch<AuditCtrlProvider>().fetchAuditForDetails!.whsCode!}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Screens.padingHeight(context) * 0.02,
                          ),
                          Container(
                            width: Screens.width(context) * 0.8,
                            height: Screens.bodyheight(context) * 0.05,
                            child: ElevatedButton(
                                onPressed: context
                                            .read<AuditCtrlProvider>()
                                            .syncdatafreeze ==
                                        true
                                    ? null
                                    : () {
                                        st(
                                          () {
                                            context
                                                .read<AuditCtrlProvider>()
                                                .checkNeworkConnectivity(
                                                    context, theme);
                                          },
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                child: const Text("Sync Data")),
                          ),
                          SizedBox(
                            height: Screens.padingHeight(context) * 0.03,
                          ),
                          Container(
                            height: Screens.padingHeight(context) * 0.05,
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.all(0),
                              thumbColor: theme.primaryColor,
                              groupValue: context
                                  .watch<AuditCtrlProvider>()
                                  .groupScanlogValueSelected,
                              children: {
                                0: Container(
                                  alignment: Alignment.center,
                                  width: Screens.width(context) * 0.3,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 5),
                                  // height: Screens.padingHeight(context) * 0.05,
                                  child: Text(
                                    'Pending',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                1: Container(
                                  alignment: Alignment.center,
                                  width: Screens.width(context) * 0.3,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 5),
                                  // height: Screens.padingHeight(context) * 0.05,
                                  child: Text(
                                    'Pushed Data',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                2: Container(
                                  alignment: Alignment.center,
                                  width: Screens.width(context) * 0.3,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 7, horizontal: 5),
                                  // height: Screens.padingHeight(context) * 0.05,
                                  child: Text(
                                    'Error',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                              },
                              onValueChanged: (v) {
                                st(
                                  () {
                                    context
                                        .read<AuditCtrlProvider>()
                                        .groupScanLogSelectvalue(v!);
                                  },
                                );
                                print('Select scan log taggle::${v}');
                              },
                            ),
                          ),
                          SizedBox(
                            height: Screens.padingHeight(context) * 0.01,
                          ),
                          context
                                      .watch<AuditCtrlProvider>()
                                      .viewerrorDetails
                                      .isNotEmpty &&
                                  // context
                                  //         .watch<AuditCtrlProvider>()
                                  //         .viewerrors ==
                                  //             true
                                  context
                                          .watch<AuditCtrlProvider>()
                                          .groupScanlogValueSelected ==
                                      2
                              ? Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          st(
                                            () {
                                              context
                                                  .read<AuditCtrlProvider>()
                                                  .saveAllExcel(context, theme);
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.document_scanner)),
                                    DataTableErrorWidget(
                                      tablerColumn: context
                                          .watch<AuditCtrlProvider>()
                                          .viewerrorDetails,
                                    ),
                                  ],
                                )
                              : context
                                              .watch<AuditCtrlProvider>()
                                              .groupScanlogValueSelected ==
                                          1 &&
                                      context
                                          .watch<AuditCtrlProvider>()
                                          .viewSuccessDetails
                                          .isNotEmpty
                                  // &&
                                  //         context
                                  //                 .watch<AuditCtrlProvider>()
                                  //                 .viewsucess ==
                                  //             true
                                  ? Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              st(
                                                () {
                                                  context
                                                      .read<AuditCtrlProvider>()
                                                      .saveAllExcel(
                                                          context, theme);
                                                },
                                              );
                                            },
                                            icon: Icon(Icons.document_scanner)),
                                        DataTableSuccess(
                                          tablerColumn: context
                                              .read<AuditCtrlProvider>()
                                              .viewSuccessDetails,
                                        ),
                                      ],
                                    )
                                  : context
                                              .read<AuditCtrlProvider>()
                                              .viewScanMainDetails
                                              .isNotEmpty &&
                                          //         context
                                          //                 .watch<AuditCtrlProvider>()
                                          //                 .viewmain ==
                                          //             true
                                          context
                                                  .read<AuditCtrlProvider>()
                                                  .groupScanlogValueSelected ==
                                              0
                                      ? Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  st(
                                                    () {
                                                      context
                                                          .read<
                                                              AuditCtrlProvider>()
                                                          .saveAllExcel(
                                                              context, theme);
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                    Icons.document_scanner)),
                                            DataTableMain(
                                              tablerColumn: context
                                                  .read<AuditCtrlProvider>()
                                                  .viewScanMainDetails,
                                            ),
                                          ],
                                        )
                                      : Container()
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: Screens.width(context),
                    height: Screens.bodyheight(context) * 0.06,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();

                          // context.read<OrderTabController>().viweDetailsClicked();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: theme.primaryColor,
                          textStyle: const TextStyle(
                              // fontSize: 12,
                              ),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )), //Radius.circular(6)
                        ),
                        child: const Text("Close")),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
