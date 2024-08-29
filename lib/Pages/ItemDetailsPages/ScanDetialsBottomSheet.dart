import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constant/Screen.dart';
import '../../Controllers/AuditController/AuditControllers.dart';

class SerialBatchDetails extends StatefulWidget {
  const SerialBatchDetails({super.key});

  @override
  State<SerialBatchDetails> createState() => _SerialBatchDetailsState();
}

class _SerialBatchDetailsState extends State<SerialBatchDetails> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: Screens.padingHeight(context) * 0.01,
        ),
        child: Form(
          key: context.watch<AuditCtrlProvider>().formkey[3],
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: Screens.padingHeight(context) * 0.01,
                  left: Screens.width(context) * 0.05,
                  right: Screens.width(context) * 0.05,
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  autofocus: true,
                  focusNode: context.watch<AuditCtrlProvider>().itemFocus,
                  readOnly:
                      context.watch<AuditCtrlProvider>().freezeItemCode == true
                          ? true
                          : false,
                  onTap: () {
                    if (context
                        .read<AuditCtrlProvider>()
                        .formkey[2]
                        .currentState!
                        .validate()) {
                      context.read<AuditCtrlProvider>().mycontroller[4].text =
                          context
                              .read<AuditCtrlProvider>()
                              .mycontroller[4]
                              .text;
                      context
                          .read<AuditCtrlProvider>()
                          .mycontroller[4]
                          .selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: context
                            .read<AuditCtrlProvider>()
                            .mycontroller[4]
                            .text
                            .length,
                      );
                    }
                  },
                  controller:
                      context.watch<AuditCtrlProvider>().mycontroller[4],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Item Code';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Screens.width(context) * 0.03,
                        vertical: Screens.fullHeight(context) * 0.01),
                    labelText: 'Item Code',
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
                height: Screens.padingHeight(context) * 0.01,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: Screens.padingHeight(context) * 0.01,
                  left: Screens.width(context) * 0.05,
                  right: Screens.width(context) * 0.05,
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  readOnly:
                      context.watch<AuditCtrlProvider>().freezeqty == true ||
                              context
                                  .watch<AuditCtrlProvider>()
                                  .mycontroller[2]
                                  .text
                                  .isEmpty
                          ? true
                          : false,
                  controller:
                      context.watch<AuditCtrlProvider>().mycontroller[5],
                  onTap: () {
                    if (context
                        .read<AuditCtrlProvider>()
                        .formkey[2]
                        .currentState!
                        .validate()) {
                      context.read<AuditCtrlProvider>().mycontroller[5].text =
                          context
                              .read<AuditCtrlProvider>()
                              .mycontroller[5]
                              .text;
                      context
                          .read<AuditCtrlProvider>()
                          .mycontroller[5]
                          .selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: context
                            .read<AuditCtrlProvider>()
                            .mycontroller[5]
                            .text
                            .length,
                      );
                    }
                  },
                  onChanged: (value) {
                    context.read<AuditCtrlProvider>().mycontroller[5].text =
                        value;
                    // log('JJJJJJJJJJJJ:${context.read<AuditCtrlProvider>().mycontroller[5].text}');
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Quantity';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Screens.width(context) * 0.03,
                        vertical: Screens.fullHeight(context) * 0.01),
                    labelText: 'Enter Quantity',
                    labelStyle:
                        theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    focusedBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(width: 1, color: Colors.black54),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                    errorBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              context.watch<AuditCtrlProvider>().dispvalList.isNotEmpty
                  ? Container(
                      child: Wrap(
                          spacing: 5.0, // width
                          runSpacing: 10.0, // height
                          children: context
                              .watch<AuditCtrlProvider>()
                              .listContainersCustomertags(
                                theme,
                                context,
                              )),
                    )
                  : Container(),
              SizedBox(
                height: Screens.padingHeight(context) * 0.02,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: Screens.width(context) * 0.05,
                  right: Screens.width(context) * 0.05,
                ),
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(left: Screens.width(context) * 0.03),
                      child: Text(
                        'Dispute',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: Screens.width(context) * 0.03,
                    ),
                    Container(
                      height: Screens.padingHeight(context) * 0.05,
                      child: CupertinoSlidingSegmentedControl<int>(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.all(0),
                        thumbColor: theme.primaryColor,
                        groupValue: context
                            .read<AuditCtrlProvider>()
                            .groupValueSelected,
                        children: {
                          0: Container(
                            alignment: Alignment.center,
                            width: Screens.width(context) * 0.15,
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            // height: Screens.padingHeight(context) * 0.05,
                            child: Text(
                              'No',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          1: Container(
                            alignment: Alignment.center,
                            width: Screens.width(context) * 0.15,
                            padding: EdgeInsets.symmetric(
                                vertical: 7, horizontal: 5),
                            // height: Screens.padingHeight(context) * 0.05,
                            child: Text(
                              'Yes',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        },
                        onValueChanged: (v) {
                          setState(() {
                            context
                                .read<AuditCtrlProvider>()
                                .groupSelectvalue(v!);
                            print('Selete taggle::${v}');
                          });
                        },
                      ),
                    )
                    // Switch(
                    //   value: disputeval,
                    //   onChanged: (value) {
                    //     setStateateateate(() {
                    //       disputeval =
                    //           value; //update value when sitch changed
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.01,
              ),
              context.watch<AuditCtrlProvider>().groupValueSelected == 1
                  ? Container(
                      padding: EdgeInsets.only(
                        left: Screens.width(context) * 0.05,
                        right: Screens.width(context) * 0.05,
                      ),
                      alignment: Alignment.center,
                      child: TextFormField(
                        autofocus: true,
                        focusNode: context.watch<AuditCtrlProvider>().noteFocus,
                        controller:
                            context.watch<AuditCtrlProvider>().mycontroller[6],
                        onTap: () {
                          if (context
                              .read<AuditCtrlProvider>()
                              .formkey[2]
                              .currentState!
                              .validate()) {
                            context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[6]
                                    .text =
                                context
                                    .read<AuditCtrlProvider>()
                                    .mycontroller[6]
                                    .text;
                            context
                                .read<AuditCtrlProvider>()
                                .mycontroller[6]
                                .selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: context
                                  .read<AuditCtrlProvider>()
                                  .mycontroller[6]
                                  .text
                                  .length,
                            );
                          }
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            context.read<AuditCtrlProvider>().apiResponseDialog(
                                context, theme, '*Enter the Notes');
                            return '* Notes';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context
                              .read<AuditCtrlProvider>()
                              .mycontroller[6]
                              .text = value;
                          if (context
                              .read<AuditCtrlProvider>()
                              .scandata
                              .isNotEmpty) {
                            log('valuevaluevalue::$value');
                            context
                                .read<AuditCtrlProvider>()
                                .scandata[0]
                                .notes = value;
                            // log('message6666666666::${scandata[0].notes}');
                          }
                        },
                        maxLength: 1000,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: Screens.width(context) * 0.03,
                              vertical: Screens.fullHeight(context) * 0.01),
                          labelText: 'Notes',
                          labelStyle: theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey),
                          focusedBorder: const OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(25),
                            borderSide:
                                BorderSide(width: 1, color: Colors.black54),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                          errorBorder: const OutlineInputBorder(
                            // borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.black54),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: Screens.padingHeight(context) * 0.02,
              ),
              Container(
                width: Screens.width(context) * 0.95,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                  top: Screens.padingHeight(context) * 0.01,
                  right: Screens.width(context) * 0.02,
                  left: Screens.width(context) * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'SKU : ${context.watch<AuditCtrlProvider>().itemCode.isNotEmpty ? context.watch<AuditCtrlProvider>().itemCode : context.read<AuditCtrlProvider>().mycontroller[4].text}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            // checkListformCreation(context, theme, 2);
                          },
                        );
                      },
                      child: Text(
                          'Item Name :${context.watch<AuditCtrlProvider>().itemName}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                    ),
                    Text(
                        'BIN : ${context.watch<AuditCtrlProvider>().mycontroller[2].text}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    Text(
                        'Scanned at : ${context.watch<AuditCtrlProvider>().scanTime}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    Text(
                        'Condition : ${context.watch<AuditCtrlProvider>().isSelectedCusTag}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.01,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.02,
              ),
              Container(
                height: Screens.padingHeight(context) * 0.05,
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      foregroundColor: Colors.white,
                      backgroundColor: theme.primaryColor),
                  onPressed: context.read<AuditCtrlProvider>().nextdisable ==
                          true
                      ? null
                      : () {
                          log('fetchAuditForDetails::${context.read<AuditCtrlProvider>().fetchAuditForDetails.docEntry}');

                          if (context
                                  .read<AuditCtrlProvider>()
                                  .networkTimeStatus ==
                              'Enabled') {
                            if (context
                                    .read<AuditCtrlProvider>()
                                    .formkey[2]
                                    .currentState!
                                    .validate() &&
                                context
                                    .read<AuditCtrlProvider>()
                                    .formkey[3]
                                    .currentState!
                                    .validate()) {
                              context.read<AuditCtrlProvider>().nextdisable =
                                  true;
                              setState(() {
                                context
                                    .read<AuditCtrlProvider>()
                                    .addscanneddata(0);
                                context.read<AuditCtrlProvider>().checknextbtn(
                                    context,
                                    theme,
                                    context
                                        .read<AuditCtrlProvider>()
                                        .mycontroller[3]
                                        .text,
                                    context
                                        .read<AuditCtrlProvider>()
                                        .mycontroller[4]
                                        .text);
                              });
                            }
                          } else {
                            context
                                .read<AuditCtrlProvider>()
                                .callTimeEnableMethod(context);
                          }
                        },
                  child: const Center(
                    child: Text('Next'),
                  ),
                ),
              ),
              SizedBox(
                height: Screens.padingHeight(context) * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
