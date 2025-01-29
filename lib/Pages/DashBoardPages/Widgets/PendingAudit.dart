import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Controllers/DashBoardController/DashBoradControllers.dart';
import '../../../Constant/Configuration.dart';
import '../../../Constant/Screen.dart';
import '../../../Controllers/AuditController/AuditControllers.dart';
import '../../../Model/AuditModel/AuditByDeviceModel.dart';
import '../../QrScannerPage/QrPage.dart';

class PendingAudits extends StatefulWidget {
  const PendingAudits({super.key});

  @override
  State<PendingAudits> createState() => _PendingAuditsState();
}

class _PendingAuditsState extends State<PendingAudits> {
  Config config = Config();
  @override
  void initState() {
    super.initState();
    context.read<DashBoardCtrlProvider>().checkNeworkConnectivity();
    context.read<AuditCtrlProvider>().fetchAuditForDetails = null;
  }

  FetchAuditDetais fetchAuditForDetails = FetchAuditDetais();
  fetchOpenDetails(GetAuditDataModel fetchAuditDetais2, int index) {
    fetchAuditForDetails = FetchAuditDetais(
        index: index,
        totalItems: fetchAuditDetais2.totalItems,
        unitsScanned: fetchAuditDetais2.unitsScanned,
        auditFrom: fetchAuditDetais2.auditFrom,
        deviceCode: fetchAuditDetais2.deviceCode,
        user: fetchAuditDetais2.user,
        auditTo: fetchAuditDetais2.auditTo,
        blockTrans: fetchAuditDetais2.blockTrans,
        createdBy: fetchAuditDetais2.createdBy,
        createdDatetime: fetchAuditDetais2.createdDatetime,
        docDate: fetchAuditDetais2.docDate,
        docEntry: fetchAuditDetais2.docEntry,
        percent: fetchAuditDetais2.percent,
        docNum: fetchAuditDetais2.docNum,
        endDate: fetchAuditDetais2.endDate,
        remarks: fetchAuditDetais2.remarks,
        repeat: fetchAuditDetais2.repeat,
        repeatDay: fetchAuditDetais2.repeatDay,
        repeatFrequency: fetchAuditDetais2.repeatFrequency,
        scheduleName: fetchAuditDetais2.scheduleName,
        startDate: fetchAuditDetais2.startDate,
        status: fetchAuditDetais2.status,
        traceid: fetchAuditDetais2.traceid,
        updatedBy: fetchAuditDetais2.updatedBy,
        updatedDatetime: fetchAuditDetais2.updatedDatetime,
        whsCode: fetchAuditDetais2.whsCode);
    log('XXXXX:::${fetchAuditForDetails.docEntry}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
          left: Screens.width(context) * 0.02,
          bottom: Screens.bodyheight(context) * 0.005,
          right: Screens.width(context) * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: Screens.width(context) * 0.01),
            child: Text('Pending Audits',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
          ),
          context.watch<DashBoardCtrlProvider>().openAuditList.isEmpty
              ? Center(
                  child: Container(
                      height: Screens.bodyheight(context) * 0.4,
                      child: Center(child: Text('No Pending Audits'))))
              : SizedBox(
                  height: Screens.bodyheight(context) * 0.43,
                  child: ListView.builder(
                      shrinkWrap: true,
                      // physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemCount: context
                          .watch<DashBoardCtrlProvider>()
                          .openAuditList
                          .length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await fetchOpenDetails(
                                context
                                    .read<DashBoardCtrlProvider>()
                                    .openAuditList[index],
                                index);
                            context
                                .read<AuditCtrlProvider>()
                                .fetchAuditForDetails = fetchAuditForDetails;

                            ScannerPageState.bincodeScan = false;
                            ScannerPageState.batchCodeScan = false;
                            ScannerPageState.searchScan = false;

                            // context
                            //     .read<AuditCtrlProvider>()
                            //     .callGetuserDetailsnApi(
                            //       int.parse(context
                            //           .read<AuditCtrlProvider>()
                            //           .fetchAuditForDetails!
                            //           .docEntry
                            //           .toString()),
                            //       context,
                            //       theme,
                            //     );

                            // // log('fetchAuditForDetails!.docEntry.toString()::${context.read<AuditCtrlProvider>().fetchAuditForDetails!.docEntry.toString()}');
                            // await context
                            //     .read<AuditCtrlProvider>()
                            //     .scantotaldeviceqty();
                            // context.read<AuditCtrlProvider>().openAuditList =
                            //     context
                            //         .read<DashBoardCtrlProvider>()
                            //         .openAuditList;
                            // if (context
                            //         .read<AuditCtrlProvider>()
                            //         .fetchAuditForDetails!
                            //         .status ==
                            //     'In-Process') {
                            //   context.read<AuditCtrlProvider>().resetaudit =
                            //       false;

                            //   await context
                            //       .read<AuditCtrlProvider>()
                            //       .getTotalLengthItems(int.parse(context
                            //           .read<AuditCtrlProvider>()
                            //           .fetchAuditForDetails!
                            //           .docEntry
                            //           .toString()));
                            //   await context
                            //       .read<AuditCtrlProvider>()
                            //       .callStockSnapApi(
                            //           context,
                            //           theme,
                            //           int.parse(context
                            //               .read<AuditCtrlProvider>()
                            //               .fetchAuditForDetails!
                            //               .docEntry
                            //               .toString()),
                            //           index);
                            // } else if (context
                            //         .read<AuditCtrlProvider>()
                            //         .fetchAuditForDetails!
                            //         .status ==
                            //     'Open') {
                            //   context
                            //       .read<AuditCtrlProvider>()
                            //       .openStatusAlertBox(theme, context);
                            // }

                            context.read<AuditCtrlProvider>().selectItemColor =
                                true;
                            await context
                                .read<DashBoardCtrlProvider>()
                                .onItemTapped(1);
                          },
                          child: Card(
                            elevation: 0,
                            child: GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ItemDetails(
                              //               title:
                              //                   '#${context.read<DashBoardCtrlProvider>().openAuditList[index].docNum} - ${context.read<DashBoardCtrlProvider>().openAuditList[index].scheduleName}')));
                              // },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black26)),
                                padding: EdgeInsets.all(
                                    Screens.bodyheight(context) * 0.008),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.6,
                                          child: Text(
                                              context
                                                  .watch<
                                                      DashBoardCtrlProvider>()
                                                  .openAuditList[index]
                                                  .scheduleName,
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: Screens.width(context) * 0.29,
                                          child: Text(
                                            '${context.watch<DashBoardCtrlProvider>().openAuditList[index].percent}%',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Colors.cyan,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Scheduled at ${config.alignDate(context.watch<DashBoardCtrlProvider>().openAuditList[index].auditFrom)}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(color: Colors.grey)),
                                        Container(
                                          alignment: Alignment.center,
                                          width: Screens.width(context) * 0.29,
                                          child: Text(
                                            context
                                                .watch<DashBoardCtrlProvider>()
                                                .openAuditList[index]
                                                .status,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Colors.cyan,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade100,
                                              width: 0.4)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Location :${context.watch<DashBoardCtrlProvider>().openAuditList[index].whsCode}',
                                                style: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.grey)),
                                            Text(
                                                'Audit By ${context.watch<DashBoardCtrlProvider>().openAuditList[index].user}',
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.grey))
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: Screens.width(context) * 0.29,
                                          child: Text(
                                            '${context.watch<DashBoardCtrlProvider>().openAuditList[index].unitsScanned}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Colors.cyan,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
        ],
      ),
    );
  }
}
