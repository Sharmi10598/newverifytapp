import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Controllers/AuditController/AuditControllers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:verifytapp/Pages/AuditPages/Widgets/ErrorTable.dart';
import '../../../Constant/Configuration.dart';
import '../../../Constant/Screen.dart';
import '../../../Services/GetAuditApi/SyncExternalStockSnapApi.dart';
import '../../ItemDetailsPages/ItemDetailsScreen.dart';
import '../../ScanSearchScreens/ScanLogSearchPage.dart';
import 'MainTables.dart';
import 'SuccessTable.dart';

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
                    //         context
                    //             .watch<AuditCtrlProvider>()
                    //             .errorMsg
                    //             .isNotEmpty &&

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

                    : context.watch<AuditCtrlProvider>().isLoading == false &&
                            context
                                .watch<AuditCtrlProvider>()
                                .openAuditList
                                .isEmpty
                        ? Container(child: Center(child: Text('No Audit Data')))
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
                                        .resetaudit = false;
                                    await context
                                        .read<AuditCtrlProvider>()
                                        .fetchOpenDetails(context
                                            .read<AuditCtrlProvider>()
                                            .openAuditList[index]);
                                    context
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

                                    // showOpenDialog(
                                    // context,
                                    // theme,
                                    // context
                                    //     .read<AuditCtrlProvider>()
                                    //     .openAuditList[index]
                                    //     .docEntry,
                                    // index);
                                  },
                                  onTap: () {
                                    //   context
                                    //       .read<AuditCtrlProvider>()
                                    //       .clearbtn();
                                    //   context
                                    //       .read<AuditCtrlProvider>()
                                    //       .mycontroller[5]
                                    //       .text = '';
                                    //   context
                                    //       .read<AuditCtrlProvider>()
                                    //       .mycontroller[4]
                                    //       .text = '';
                                    //   context.read<AuditCtrlProvider>().incQty =
                                    //       0;
                                    //   context
                                    //       .read<AuditCtrlProvider>()
                                    //       .fetchOpenDetails(context
                                    //           .read<AuditCtrlProvider>()
                                    //           .openAuditList[index]);
                                    //   // log('messageCCCCCCCCCCC::${context.read<AuditCtrlProvider>().openAuditList[index].deviceCode}');
                                    //   context
                                    //       .read<AuditCtrlProvider>()
                                    //       .callGetBinNumApiApi(
                                    //           context
                                    //               .read<AuditCtrlProvider>()
                                    //               .openAuditList[index]
                                    //               .docEntry,
                                    //           context,
                                    //           theme);

                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) => ItemDetails(
                                    //               title:
                                    //                   '#${context.read<AuditCtrlProvider>().openAuditList[index].docNum} - ${context.read<AuditCtrlProvider>().openAuditList[index].scheduleName}')));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        border:
                                            Border.all(color: Colors.black26)),
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

  callStockSnapApi(
      BuildContext context, ThemeData theme, int docEntry, int index) {
    SyncExternalStockApi.getData(
            context.read<AuditCtrlProvider>().fetchAuditForDetails.whsCode!)
        .then((value) {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text('Check Your Internet..!!'),
        //   backgroundColor: Colors.red,
        //   elevation: 10,
        //   behavior: SnackBarBehavior.floating,
        //   margin: EdgeInsets.all(5),
        //   dismissDirection: DismissDirection.up,
        // ));
      }
    });
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
                              setState(() {
                                context.read<AuditCtrlProvider>().resetaudit =
                                    true;
                                context
                                    .read<AuditCtrlProvider>()
                                    .isClickedStart = false;
                                String mssgg =
                                    "Downloading item data takes some time";
                                context.read<AuditCtrlProvider>().checktimediv(
                                    context, theme, mssgg, '', docEntry, index);
                              });
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
                            onPressed: () {
                              setState(() {
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
                                    .callGetBinNumApiApi(
                                        context
                                            .read<AuditCtrlProvider>()
                                            .openAuditList[index]
                                            .docEntry,
                                        context,
                                        theme);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemDetails(
                                            title:
                                                '#${context.read<AuditCtrlProvider>().openAuditList[index].docNum} - ${context.read<AuditCtrlProvider>().openAuditList[index].scheduleName}')));
                              });
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
                              setState(() {
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[0]
                                    .text = '';
                                showRescheduleDialog(context, theme, docEntry);
                              });
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
                              setState(() {
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[1]
                                    .text = '';
                                showAbortDialog(context, theme, docEntry);
                              });
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
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ScanLogsSearch()));
                              });
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
                              setState(() {
                                context.read<AuditCtrlProvider>().viewmain =
                                    true;
                                context.read<AuditCtrlProvider>().viewerrors =
                                    false;
                                context.read<AuditCtrlProvider>().viewsucess =
                                    false;
                                context
                                    .read<AuditCtrlProvider>()
                                    .getScannedInformation(docEntry);

                                scanLogsDetailsDialog(context, theme);

                                context
                                    .read<AuditCtrlProvider>()
                                    .syncdatafreeze = false;
                              });
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
                  setState(() {
                    context.read<AuditCtrlProvider>().callGetuserDetailsnApi(
                          docEntry,
                          context,
                          theme,
                        );
                    showViewDetailsDialog(context, theme);
                  });
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

  showViewDetailsDialog(BuildContext context, ThemeData theme) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                content: auditDetailsDialog(context, theme));
          });
        });
  }

  showRescheduleDialog(BuildContext context, ThemeData theme, int docEntry) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                content: rescheduleDatePopUp(context, theme, docEntry));
          });
        });
  }

  Container rescheduleDatePopUp(
      BuildContext context, ThemeData theme, int docEntry) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      // height: Screens.padingHeight(context) * 0.2,
      width: Screens.width(context) * 0.9,
      child: Form(
        key: context.watch<AuditCtrlProvider>().formkey[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              height: Screens.bodyheight(context) * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Screens.width(context) * 0.7,
                    child: Center(
                        child: Text("Reschedule",
                            style: theme.textTheme.bodyLarge!
                                .copyWith(color: Colors.white))),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close, color: Colors.white))
                ],
              ),
            ),
            SizedBox(
              height: Screens.padingHeight(context) * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: Screens.padingHeight(context) * 0.01,
                  right: Screens.padingHeight(context) * 0.01),
              color: Colors.white,
              alignment: Alignment.center,
              child: TextFormField(
                onTap: () {
                  context.read<AuditCtrlProvider>().showDate(context);
                },
                controller: context.read<AuditCtrlProvider>().mycontroller[0],
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return '*Schedule date is mandatory';
                  }
                  //  else if (value.isNotEmpty) {
                  //   if (value == DateTime.now().toString()) {
                  //     return "Please Enter the Future Date";
                  //   }
                  // }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Screens.width(context) * 0.03,
                      vertical: Screens.fullHeight(context) * 0.01),
                  labelText: 'Enter Schedule Date',
                  suffixIcon: Icon(
                    Icons.calendar_month,
                    color: theme.primaryColor,
                  ),
                  labelStyle:
                      theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
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
            context.watch<AuditCtrlProvider>().validteText.isNotEmpty
                ? Container(
                    padding:
                        EdgeInsets.only(left: Screens.width(context) * 0.03),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.watch<AuditCtrlProvider>().validteText,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.red),
                    ))
                : Container(),
            SizedBox(
              height: Screens.padingHeight(context) * 0.02,
            ),
            Container(
              width: Screens.width(context) * 0.9,
              height: Screens.bodyheight(context) * 0.06,
              child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      // context
                      //     .read<AuditCtrlProvider>()
                      //     .apiResponseDialog(context, theme, 'Success');
                      context
                          .read<AuditCtrlProvider>()
                          .validateReschedule(context, theme, docEntry);
                    });
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
                  child: const Text("OK")),
            ),
            // Container(
            //     width: Screens.width(context) * 0.5,
            //     child: ElevatedButton(
            //         onPressed: () async {
            //           // await GetAuditRescheduleApi.getData();
            //           notifyListeners();
            //         },
            //         child: Text('OK')))
          ],
        ),
      ),
    );
  }

  showAbortDialog(BuildContext context, ThemeData theme, int docEntry) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                content: abortPopUp(context, theme, docEntry));
          });
        });
  }

  Container abortPopUp(BuildContext context, ThemeData theme, int docEntry) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      // height: Screens.padingHeight(context) * 0.2,
      width: Screens.width(context) * 0.9,
      child: Form(
        key: context.watch<AuditCtrlProvider>().formkey[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              height: Screens.bodyheight(context) * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Screens.width(context) * 0.7,
                    child: Center(
                        child: Text("Abort",
                            style: theme.textTheme.bodyLarge!
                                .copyWith(color: Colors.white))),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close, color: Colors.white))
                ],
              ),
            ),
            SizedBox(
              height: Screens.padingHeight(context) * 0.02,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: Screens.padingHeight(context) * 0.01,
                  right: Screens.padingHeight(context) * 0.01),
              color: Colors.white,
              alignment: Alignment.center,
              child: TextFormField(
                controller: context.watch<AuditCtrlProvider>().mycontroller[1],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Reason';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: Screens.width(context) * 0.03,
                      vertical: Screens.fullHeight(context) * 0.01),
                  labelText: 'Enter Reason',
                  // suffixIcon: Icon(
                  //   Icons.calendar_month,
                  //   color: theme.primaryColor,
                  // ),
                  labelStyle:
                      theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
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
              height: Screens.padingHeight(context) * 0.02,
            ),
            Container(
              width: Screens.width(context) * 0.9,
              height: Screens.bodyheight(context) * 0.06,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      context
                          .read<AuditCtrlProvider>()
                          .validateAbort(docEntry, context, theme);
                    });
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
                  child: const Text("OK")),
            ),
            // Container(
            //     width: Screens.width(context) * 0.5,
            //     child: ElevatedButton(
            //         onPressed: () async {
            //           // await GetAuditRescheduleApi.getData();
            //           notifyListeners();
            //         },
            //         child: Text('OK')))
          ],
        ),
      ),
    );
  }

  Container auditDetailsDialog(BuildContext context, ThemeData theme) {
    return Container(
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
                  child: Text("Audit Details",
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
                          width: Screens.width(context) * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${context.watch<AuditCtrlProvider>().fetchAuditForDetails.scheduleName}',
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: Screens.padingHeight(context) * 0.01,
                              ),
                              Text(
                                  'Audit From : ${config.alignDate(context.watch<AuditCtrlProvider>().fetchAuditForDetails.auditFrom.toString())}'),
                              Text(
                                  'Audit To      : ${config.alignDate(context.watch<AuditCtrlProvider>().fetchAuditForDetails.auditTo.toString())}'),
                            ],
                          ),
                        ),
                        Container(
                          width: Screens.width(context) * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doc Num    : ${context.watch<AuditCtrlProvider>().fetchAuditForDetails.docNum}',
                              ),
                              Text(
                                  'Status  : ${context.watch<AuditCtrlProvider>().fetchAuditForDetails.status}'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.04,
                  ),
                  createTable(theme),
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
    );
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
                                      Text(
                                          'Pushed to Server : ${context.watch<AuditCtrlProvider>().totalSuccess} '),
                                      Text(
                                          'Errors in Sync       : ${context.watch<AuditCtrlProvider>().totalError} '),
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
                                        setState(() {
                                          context
                                              .read<AuditCtrlProvider>()
                                              .checkNeworkConnectivity(
                                                  context, theme);
                                        });
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(0),
                                // width: Screens.width(context) * 0.25,
                                height: Screens.bodyheight(context) * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: context
                                                  .read<AuditCtrlProvider>()
                                                  .viewmain ==
                                              true
                                          ? theme.primaryColor.withOpacity(0.5)
                                          : theme.primaryColor,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                    ),
                                    onPressed: () {
                                      st(() {
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewmain = true;
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewsucess = false;
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewerrors = false;
                                        print(context
                                            .read<AuditCtrlProvider>()
                                            .viewmain);
                                        log(context
                                            .read<AuditCtrlProvider>()
                                            .viewScanMainDetails
                                            .length
                                            .toString());
                                      });
                                    },
                                    child: Text(
                                      'Pending',
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        // decoration:
                                        //     TextDecoration.underline,
                                        // decorationColor: Colors.blue,
                                        // decorationStyle:
                                        //     TextDecorationStyle.solid
                                      ),
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.all(2),
                                // width: Screens.width(context) * 0.25,
                                height: Screens.bodyheight(context) * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(3),
                                      backgroundColor: context
                                                  .read<AuditCtrlProvider>()
                                                  .viewsucess ==
                                              true
                                          ? theme.primaryColor.withOpacity(0.5)
                                          : theme.primaryColor,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                    ),
                                    onPressed: () {
                                      st(() {
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewsucess = true;
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewerrors = false;
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewmain = false;
                                        print(context
                                            .read<AuditCtrlProvider>()
                                            .viewerrors);
                                        print(context
                                            .read<AuditCtrlProvider>()
                                            .viewSuccessDetails
                                            .length);
                                      });
                                    },
                                    child: Text(
                                      'Pushed Data',
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                width: Screens.width(context) * 0.25,
                                height: Screens.bodyheight(context) * 0.05,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: context
                                                  .read<AuditCtrlProvider>()
                                                  .viewerrors ==
                                              true
                                          ? theme.primaryColor.withOpacity(0.5)
                                          : theme.primaryColor,
                                      foregroundColor: Colors.white,
                                      textStyle: const TextStyle(),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(6))),
                                    ),
                                    onPressed: () {
                                      st(() {
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewerrors = true;

                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewsucess = false;
                                        context
                                            .read<AuditCtrlProvider>()
                                            .viewmain = false;
                                        print(context
                                            .read<AuditCtrlProvider>()
                                            .viewerrors);
                                        print(context
                                            .read<AuditCtrlProvider>()
                                            .viewerrorDetails
                                            .length);
                                      });
                                    },
                                    child: Text(
                                      'Errors',
                                      style:
                                          theme.textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                        // decoration:
                                        //     TextDecoration.underline,
                                        // decorationColor: Colors.blue,
                                        // decorationStyle:
                                        //     TextDecorationStyle.solid
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Screens.padingHeight(context) * 0.01,
                          ),
                          context
                                      .watch<AuditCtrlProvider>()
                                      .viewerrorDetails
                                      .isNotEmpty &&
                                  context
                                          .watch<AuditCtrlProvider>()
                                          .viewerrors ==
                                      true
                              ? Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            context
                                                .read<AuditCtrlProvider>()
                                                .saveAllExcel(context, theme);
                                          });
                                        },
                                        icon: Icon(Icons.document_scanner)),
                                    DataTableErrorWidget(
                                      tablerColumn: context
                                          .read<AuditCtrlProvider>()
                                          .viewerrorDetails,
                                    ),
                                  ],
                                )
                              : context
                                          .watch<AuditCtrlProvider>()
                                          .viewSuccessDetails
                                          .isNotEmpty &&
                                      context
                                              .watch<AuditCtrlProvider>()
                                              .viewsucess ==
                                          true
                                  ? Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                context
                                                    .read<AuditCtrlProvider>()
                                                    .saveAllExcel(
                                                        context, theme);
                                              });
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
                                              .watch<AuditCtrlProvider>()
                                              .viewScanMainDetails
                                              .isNotEmpty &&
                                          context
                                                  .watch<AuditCtrlProvider>()
                                                  .viewmain ==
                                              true
                                      ? Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    context
                                                        .read<
                                                            AuditCtrlProvider>()
                                                        .saveAllExcel(
                                                            context, theme);
                                                  });
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

  Widget createTable(ThemeData theme) {
    List<TableRow> rows = [];
    rows.add(TableRow(children: [
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "User Code",
          style: theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "User Name",
          style: theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        color: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Text(
          "Audit Role",
          style: theme.textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    ]));
    for (int i = 0;
        i < context.watch<AuditCtrlProvider>().usetDetailData.length;
        ++i) {
      rows.add(TableRow(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            '${context.watch<AuditCtrlProvider>().usetDetailData[i].userCode}',
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context.watch<AuditCtrlProvider>().usetDetailData[i].username,

            // '${context.watch<QuotestabController>().getleadDeatilsQTLData[i].Price!.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Text(
            context.watch<AuditCtrlProvider>().usetDetailData[i].auditRole,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.primaryColor,
            ),
          ),
        ),
      ]));
    }

    return Table(columnWidths: {
      0: const FlexColumnWidth(1.5),
      1: const FlexColumnWidth(2),
      2: const FlexColumnWidth(2),
    }, children: rows);
  }
}
