import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Constant/Configuration.dart';
import 'package:verifytapp/Constant/Screen.dart';

import '../../Controllers/SearchController/SerchControllers.dart';

class ScanLogsSearch extends StatefulWidget {
  const ScanLogsSearch({super.key});

  @override
  State<ScanLogsSearch> createState() => _ScanLogsSearchState();
}

class _ScanLogsSearchState extends State<ScanLogsSearch> {
  Config config = Config();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SearchCtrl>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: theme.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: Screens.padingHeight(context) * 0.015,
              bottom: Screens.padingHeight(context) * 0.02,
              left: Screens.width(context) * 0.02,
              right: Screens.width(context) * 0.02),
          height: Screens.padingHeight(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Screens.padingHeight(context) * 0.055,
                alignment: Alignment.center,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      context.read<SearchCtrl>().filterSearchBoxList(value);
                    });
                  },
                  controller: context.watch<SearchCtrl>().SearchController,
                  autofocus: true,
                  onEditingComplete: () {},
                  onTap: () {},
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Screens.width(context) * 0.03,
                        vertical: Screens.fullHeight(context) * 0.01),
                    labelText: 'Search Scan Logs',
                    labelStyle:
                        theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              context.watch<SearchCtrl>().fileterSearchValues.length < 1
                  ? Container(
                      height: Screens.padingHeight(context) * 0.7,
                      child: Center(child: Text('No data found..!!')))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: context
                              .watch<SearchCtrl>()
                              .fileterSearchValues
                              .length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 0,
                              child: GestureDetector(
                                onDoubleTap: () async {},
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: context
                                                  .watch<SearchCtrl>()
                                                  .fileterSearchValues[index]
                                                  .status ==
                                              'Scanned'
                                          ? Color.fromARGB(255, 204, 225, 242)
                                          : context
                                                      .watch<SearchCtrl>()
                                                      .fileterSearchValues[
                                                          index]
                                                      .status ==
                                                  'Synced'
                                              ? const Color.fromARGB(
                                                  255, 210, 231, 210)
                                              : const Color.fromARGB(
                                                  255, 244, 205, 209),
                                      border:
                                          Border.all(color: Colors.black26)),
                                  padding: EdgeInsets.all(
                                      Screens.padingHeight(context) * 0.008),
                                  child: Container(
                                      width: Screens.width(context) * 0.53,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width:
                                                  Screens.width(context) * 0.57,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      context
                                                          .watch<SearchCtrl>()
                                                          .fileterSearchValues[
                                                              index]
                                                          .itemCode!,
                                                      style: theme
                                                          .textTheme.titleMedium
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Text(
                                                      "Serial : " +
                                                          context
                                                              .watch<
                                                                  SearchCtrl>()
                                                              .fileterSearchValues[
                                                                  index]
                                                              .serialbatch!,
                                                      style: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey)),
                                                  context
                                                          .watch<SearchCtrl>()
                                                          .fileterSearchValues[
                                                              index]
                                                          .stockstatus!
                                                          .isNotEmpty
                                                      ? Text(
                                                          "Status : " +
                                                              context
                                                                  .watch<
                                                                      SearchCtrl>()
                                                                  .fileterSearchValues[
                                                                      index]
                                                                  .stockstatus!,
                                                          style: theme.textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .grey))
                                                      : Container(),
                                                  context
                                                          .watch<SearchCtrl>()
                                                          .fileterSearchValues[
                                                              index]
                                                          .notes!
                                                          .isNotEmpty
                                                      ? Text(
                                                          "Dispute : " +
                                                              context
                                                                  .watch<
                                                                      SearchCtrl>()
                                                                  .fileterSearchValues[
                                                                      index]
                                                                  .notes!,
                                                          style: theme.textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .grey))
                                                      : Container(),
                                                  Text(
                                                      'Scanned at ${config.alignDate(context.watch<SearchCtrl>().fileterSearchValues[index].scandatetime!)}',
                                                      style: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey)),
                                                ],
                                              )),
                                          Container(
                                              width:
                                                  Screens.width(context) * 0.3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        "Qty : " +
                                                            context
                                                                .watch<
                                                                    SearchCtrl>()
                                                                .fileterSearchValues[
                                                                    index]
                                                                .quantity
                                                                .toString(),
                                                        style: theme.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                // fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .grey)),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        'Location : ${context.watch<SearchCtrl>().fileterSearchValues[index].whscode}',
                                                        style: theme.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .grey)),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      )
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Row(
                                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         Container(
                                      //           width: Screens.width(context) * 0.57,
                                      // child: Text(
                                      //     context
                                      //         .watch<SearchCtrl>()
                                      //         .fileterSearchValues[index]
                                      //         .itemCode!,
                                      //     style:
                                      //         theme.textTheme.titleMedium?.copyWith(
                                      //       fontWeight: FontWeight.bold,
                                      //     )),
                                      //         ),
                                      //              Container(
                                      //           alignment: Alignment.centerRight,
                                      //           width: Screens.width(context) * 0.3,
                                      // child: Text(
                                      //     "Qty : " +
                                      //         context
                                      //             .watch<SearchCtrl>()
                                      //             .fileterSearchValues[index]
                                      //             .quantity
                                      //             .toString(),
                                      //     style: theme.textTheme.bodyMedium
                                      //         ?.copyWith(
                                      //             // fontWeight: FontWeight.bold,
                                      //             color: Colors.grey)),
                                      //         ),
                                      //       ],
                                      //     ),

                                      //     Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      // Container(
                                      //   width: Screens.width(context) * 0.57,
                                      //   child: Text(
                                      //       "Serial : " +
                                      //           context
                                      //               .watch<SearchCtrl>()
                                      //               .fileterSearchValues[index]
                                      //               .serialbatch!,
                                      //       style: theme.textTheme.bodyMedium
                                      //           ?.copyWith(
                                      //               // fontWeight: FontWeight.bold,
                                      //               color: Colors.grey)),
                                      // ),
                                      //          Container(
                                      //           width: Screens.width(context) * 0.3,
                                      // child: Text(
                                      //     "Status : " +
                                      //         context
                                      //             .watch<SearchCtrl>()
                                      //             .fileterSearchValues[index]
                                      //             .stockstatus!,
                                      //     style: theme.textTheme.bodyMedium
                                      //         ?.copyWith(
                                      //             // fontWeight: FontWeight.bold,
                                      //             color: Colors.grey)),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     Row(
                                      //       crossAxisAlignment: CrossAxisAlignment.end,
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceBetween,
                                      //       children: [
                                      //         Container(
                                      //           width: Screens.width(context) * 0.55,
                                      //   child: Text(
                                      //       'Scanned at ${config.alignDate(context.watch<SearchCtrl>().fileterSearchValues[index].scandatetime!)}',
                                      //       style: theme.textTheme.bodyMedium
                                      //           ?.copyWith(color: Colors.grey)),
                                      // ),
                                      //         Container(
                                      //           alignment: Alignment.centerLeft,
                                      //           width: Screens.width(context) * 0.3,
                                      // child: Text(
                                      //     'Location : ${context.watch<SearchCtrl>().fileterSearchValues[index].whscode}',
                                      //     style: theme.textTheme.bodyMedium
                                      //         ?.copyWith(color: Colors.grey)),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),

                                      ),
                                ),
                              ),
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
