import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Constant/Screen.dart';
import '../../../Controllers/AuditController/AuditControllers.dart';
import '../../../Model/ScanPostModel/ScanPostDataaModel.dart';

class GetImageFilePage extends StatefulWidget {
  const GetImageFilePage({super.key});

  @override
  State<GetImageFilePage> createState() => _GetImageFilePageState();
}

class _GetImageFilePageState extends State<GetImageFilePage> {
  List<TextEditingController> chkListController =
      List.generate(100, (i) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: Screens.width(context) * 0.03,
            top: Screens.padingHeight(context) * 0.02,
            right: Screens.width(context) * 0.03,
            bottom: Screens.padingHeight(context) * 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: Screens.width(context),
                alignment: Alignment.center,
                child: Text(
                  '${context.watch<AuditCtrlProvider>().getckeckDataListForm55[0].templateName}',
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                )),
            Container(
                height: Screens.padingHeight(context) * 0.4,
                width: Screens.width(context),
                child: ListView.builder(
                    shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemCount: context
                        .watch<AuditCtrlProvider>()
                        .getckeckDataListForm55
                        .length,
                    itemBuilder: (context, index) {
                      var litstagex = context
                          .watch<AuditCtrlProvider>()
                          .getckeckDataListForm55[index]
                          .listValue!
                          .split(',');
                      log('litstagexlitstagex11::${context.watch<AuditCtrlProvider>().getckeckDataListForm55[index].acceptAttach}');
                      return Column(
                        children: [
                          Container(
                            height: Screens.padingHeight(context) * 0.1,
                            padding: EdgeInsets.all(5),
                            width: Screens.width(context),
                            // child:
                            // Form(
                            //   key: context
                            //       .watch<AuditCtrlProvider>()
                            //       .checkformkey,
                            child: TextFormField(
                              readOnly: true,
                              autofocus: true,
                              controller: chkListController[index],
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                labelText:
                                    '${context.watch<AuditCtrlProvider>().getckeckDataListForm55[index].checklistName}',
                                // hintText:
                                //     '${context.watch<AuditCtrlProvider>().getckeckDataListForm55[index].checklistName}',
                                suffixIcon: Container(
                                  padding: EdgeInsets.all(10),

                                  // padding: EdgeInsets.only(
                                  //     left: Screens.width(context) * 0.03),
                                  height: Screens.padingHeight(context) * 0.09,
                                  width: Screens.width(context) * 0.95,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: litstagex.length,
                                    itemBuilder: (context, indexx) {
                                      context
                                          .read<AuditCtrlProvider>()
                                          .filenamedet
                                          .add(FileNameDet(
                                              name: '', indexId: indexx));
                                      log('litstagexlitstagex::${litstagex[indexx].toString()}');
                                      log('filenamedet length::${context.read<AuditCtrlProvider>().filenamedet.length.toString()}');
                                      return Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: litstagex[indexx] ==
                                                          context
                                                              .watch<
                                                                  AuditCtrlProvider>()
                                                              .getckeckDataListForm55[
                                                                  index]
                                                              .isselectlistval!
                                                      ? theme.primaryColor
                                                          .withOpacity(0.3)
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: theme.primaryColor,
                                                      width: 1)),
                                              padding: EdgeInsets.only(
                                                  left: Screens.width(context) *
                                                      0.03,
                                                  right:
                                                      Screens.width(context) *
                                                          0.03),
                                              height: Screens.padingHeight(
                                                      context) *
                                                  0.06,
                                              child: IconButton(
                                                  icon: context
                                                              .watch<
                                                                  AuditCtrlProvider>()
                                                              .getckeckDataListForm55[
                                                                  index]
                                                              .acceptAttach ==
                                                          true
                                                      ? Icon(Icons.attach_file,
                                                          color: theme
                                                              .primaryColor)
                                                      : Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            litstagex[indexx]
                                                                .toString(),
                                                            style: theme
                                                                .textTheme
                                                                .bodyLarge
                                                                ?.copyWith(
                                                                    color: theme
                                                                        .primaryColor),
                                                          ),
                                                        ),
                                                  onPressed: () {
                                                    if (context
                                                            .read<
                                                                AuditCtrlProvider>()
                                                            .getckeckDataListForm55[
                                                                index]
                                                            .acceptAttach ==
                                                        true) {
                                                      log('Image checklistdata length::${context.read<AuditCtrlProvider>().checklistdata.length}');

                                                      log('index::${index}');
                                                      setState(() {
                                                        context
                                                            .read<
                                                                AuditCtrlProvider>()
                                                            .imageBottomSheet(
                                                                context,
                                                                indexx);

                                                        log('urlImageurlImage:${context.read<AuditCtrlProvider>().urlImage}');

                                                        context.read<AuditCtrlProvider>().checklistdata.add(DispListData(
                                                            attachurl: context
                                                                    .read<
                                                                        AuditCtrlProvider>()
                                                                    .urlImage
                                                                    .isNotEmpty
                                                                ? context
                                                                    .read<
                                                                        AuditCtrlProvider>()
                                                                    .urlImage
                                                                : '',
                                                            auditid: context
                                                                .read<
                                                                    AuditCtrlProvider>()
                                                                .getckeckDataListForm55[
                                                                    index]
                                                                .docEntry,
                                                            checklistcode: context
                                                                .read<
                                                                    AuditCtrlProvider>()
                                                                .getckeckDataListForm55[
                                                                    index]
                                                                .checklistCode,
                                                            checklistvalue: context
                                                                .read<
                                                                    AuditCtrlProvider>()
                                                                .isSelectedCusTag,
                                                            scanguid: ''));
                                                      });
                                                    } else {
                                                      setState(() {
                                                        context
                                                                .read<
                                                                    AuditCtrlProvider>()
                                                                .getckeckDataListForm55[
                                                                    index]
                                                                .isselectlistval =
                                                            litstagex[indexx];
                                                        log('messagevalvalaval::${litstagex[indexx].toString()}');

                                                        log('indexxindexxindexx::${context.read<AuditCtrlProvider>().isselected}');

                                                        context
                                                                .read<
                                                                    AuditCtrlProvider>()
                                                                .getckeckDataListForm55[
                                                                    index]
                                                                .isselectlistval ==
                                                            true;
                                                        log('${context.read<AuditCtrlProvider>().getckeckDataListForm55[index].isselectlistval}');
                                                        log('message list::${litstagex[indexx]}');

                                                        log('messageXXXXXXX:${context.read<AuditCtrlProvider>().getckeckDataListForm55[index].checklistCode}');
                                                        context
                                                            .read<
                                                                AuditCtrlProvider>()
                                                            .onTapCheckListVal(
                                                                index,
                                                                litstagex[
                                                                    indexx]);
                                                      });
                                                    }
                                                  }),
                                            ),
                                            SizedBox(
                                                width: Screens.width(context) *
                                                    0.02),
                                            context
                                                            .read<
                                                                AuditCtrlProvider>()
                                                            .getckeckDataListForm55[
                                                                index]
                                                            .acceptAttach ==
                                                        true &&
                                                    context
                                                        .read<
                                                            AuditCtrlProvider>()
                                                        .filenamedet
                                                        .isNotEmpty
                                                ? Text(context
                                                    .read<AuditCtrlProvider>()
                                                    .filenamedet[indexx]
                                                    .name
                                                    .toString())
                                                : Container(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      );
                    })),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  foregroundColor: Colors.white,
                  backgroundColor: theme.primaryColor),
              onPressed: () {
                if (context
                    .read<AuditCtrlProvider>()
                    .checklistdata
                    .isNotEmpty) {
                  setState(() {
                    context.read<AuditCtrlProvider>().insertCheckListData();
                  });
                  Get.back();
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: Container(
                            height: Screens.padingHeight(context) * 0.15,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.03,
                                ),
                                const Text('Choose Checklist values'),
                                SizedBox(
                                  height: Screens.padingHeight(context) * 0.03,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        foregroundColor: Colors.white,
                                        backgroundColor: theme.primaryColor),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(child: const Text(' OK ')))
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
              child: const Center(
                child: Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FileNameDet {
  String name;
  int indexId;
  FileNameDet({required this.name, required this.indexId});
}
