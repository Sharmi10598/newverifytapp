import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Constant/ConstantRoutes.dart';
import 'package:verifytapp/Constant/Screen.dart';
import 'package:verifytapp/Controllers/LebelprintController/LabelprintController.dart';
import 'package:verifytapp/Pages/LabelPrinting/widgets/datatablewidget.dart';
import 'package:verifytapp/Pages/QrScannerPage/QrPage.dart';

class Lebelprint extends StatefulWidget {
  const Lebelprint({super.key});

  @override
  State<Lebelprint> createState() => _LebelprintState();
}

class _LebelprintState extends State<Lebelprint> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LabelPrintcontrller>().init();
    });
  }

  DateTime? currentBackPressTime;

  Future<bool> onbackpress() {
    DateTime now = DateTime.now();

    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      print("object");
      Get.offAllNamed(ConstantRoutes.dashboard);
      return Future.value(true);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didpop) {
        if (didpop) return;
        onbackpress();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          titleTextStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text("Label Printing"),
        ),
        body: Container(
          width: Screens.width(context),
          height: Screens.bodyheight(context)*0.95,
          // color: Colors.amber,
          // padding: EdgeInsets.only(
          //   bottom: Screens.padingHeight(context)*0.05
          // ),
          child: Stack(
            children: [
              Column(
                children: [
                  context.read<LabelPrintcontrller>().itemcodeload == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Screens.padingHeight(context) * 0.01,
                              horizontal: Screens.width(context) * 0.02),
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  controller: context
                                      .read<LabelPrintcontrller>()
                                      .mycontroller[0],
                                  onEditingComplete: () {
                                    if (context
                                        .read<LabelPrintcontrller>()
                                        .mycontroller[0]
                                        .text
                                        .isNotEmpty) {
                                      context
                                          .read<LabelPrintcontrller>()
                                          .checkitemcode(
                                              context
                                                  .read<LabelPrintcontrller>()
                                                  .mycontroller[0]
                                                  .text
                                                  .toString(),
                                              context);
                                    }
                                  },
                                  onChanged: (v) {
                                    if (v.isNotEmpty) {
                                      setState(() {
                                        context
                                            .read<LabelPrintcontrller>()
                                            .serachitemcode = true;
                                        context
                                            .read<LabelPrintcontrller>()
                                            .SearchFilteTab(v);
                                      });
                                    } else {
                                      setState(() {
                                        context
                                            .read<LabelPrintcontrller>()
                                            .serachitemcode = false;
                                        // context.read<LabelPrintcontrller>().   SearchFilteTab(v);
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                         ScannerPageState.labelprintscan = true;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ScannerPage()));
                                      },
                                      icon: Icon(
                                        Icons.qr_code_2_sharp,
                                        size: 23,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            Screens.width(context) * 0.03,
                                        vertical:
                                            Screens.fullHeight(context) * 0.01),
                                    labelText: 'Item Code',
                                    labelStyle: theme.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.grey),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1, color: Colors.grey),
                                    ),
                                    focusedErrorBorder:
                                        const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : SizedBox(
                                      height:
                                          Screens.padingHeight(context) * 0.01,
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : Row(
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.25,
                                          child: Text(
                                            "Item Name ",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          // width: Screens.width(context)*0.3,
                                          child: Text(
                                            ": ",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: Screens.width(context) * 0.65,
                                          child: Text(
                                              "${context.read<LabelPrintcontrller>().mycontroller[1].text}"),
                                        )
                                      ],
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : SizedBox(
                                      height:
                                          Screens.padingHeight(context) * 0.01,
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerRight,
                                          width: Screens.width(context) * 0.3,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: Screens.width(context) *
                                                    0.25,
                                                child: Text(
                                                  "Managed By",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                          color: theme
                                                              .primaryColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                // width: Screens.width(context)*0.3,
                                                child: Text(
                                                  ": ",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                        fontWeight: FontWeight.bold,
                                                          color: theme
                                                              .primaryColor),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                    "${context.read<LabelPrintcontrller>().mycontroller[2].text}"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : SizedBox(
                                      height:
                                          Screens.padingHeight(context) * 0.01,
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.5,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: Screens.width(context) *
                                                    0.25,
                                                child: Text(
                                                  "Stock Qty",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                          color: theme
                                                              .primaryColor,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15),
                                                ),
                                              ),
                                              Container(
                                                // width: Screens.width(context)*0.3,
                                                child: Text(
                                                  ": ",
                                                  style: theme
                                                      .textTheme.bodyMedium!
                                                      .copyWith(
                                                        fontWeight: FontWeight.bold,
                                                          color: theme
                                                              .primaryColor),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                    "${context.read<LabelPrintcontrller>().mycontroller[4].text}"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : SizedBox(
                                      height:
                                          Screens.padingHeight(context) * 0.01,
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : Row(
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.2,
                                          child: Text(
                                            "Label Qty",
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                    color: theme.primaryColor,fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                          child: Text(" : ",
                                          style: theme.textTheme.bodyMedium!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                          ),
                                          ),
                                        ),
                                        Container(
                                          width: Screens.width(context) * 0.73,
                                          // height: Screens.padingHeight(context)*0,
                                          child: TextFormField(
                                            controller: context
                                                .read<LabelPrintcontrller>()
                                                .mycontroller[3],
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: Screens.width(
                                                              context) *
                                                          0.03,
                                                      vertical:
                                                          Screens.fullHeight(
                                                                  context) *
                                                              0.01),
                                              labelText: 'Label Qty',
                                              labelStyle: theme
                                                  .textTheme.bodyLarge
                                                  ?.copyWith(
                                                      color: Colors.grey),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                              ),
                                              focusedErrorBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              errorBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : SizedBox(
                                      height:
                                          Screens.padingHeight(context) * 0.02,
                                    ),
                              context
                                          .watch<LabelPrintcontrller>()
                                          .showaditinalcolumn ==
                                      false
                                  ? Container()
                                  : Row(
                                      children: [
                                        Container(
                                          width: Screens.width(context) * 0.96,
                                          // color: Colors.amber,
                                          height:
                                              Screens.padingHeight(context) *
                                                  0.05,
                                          // alignment: Alignment.centerLeft,
                                          child: ElevatedButton(
                                              onPressed: context
                                                          .watch<
                                                              LabelPrintcontrller>()
                                                          .generateload ==
                                                      true
                                                  ? () {}
                                                  : () {
                                                      setState(() {
                                                        context
                                                            .read<
                                                                LabelPrintcontrller>()
                                                            .insertscandata();
                                                      });
                                                    },
                                              child: Text("Generate")),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                  Expanded(
                      child: context
                              .read<LabelPrintcontrller>()
                              .addLabelscandata
                              .isEmpty
                          ? Container()
                          : Container(
                              color: Colors.white,
                              child: labeltable(
                                  getallLabelscandata: context
                                      .read<LabelPrintcontrller>()
                                      .addLabelscandata),
                            )),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Screens.width(context) * 0.02,
                        vertical: Screens.padingHeight(context) * 0.01),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Screens.padingHeight(context) * 0.01,
                        ),
                        Row(
                          children: [
                            Container(
                              width: Screens.width(context) * 0.25,
                              child: Text(
                                "Label Type",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                            Container(
                              // width: Screens.width(context)*0.25,
                              child: Text(": ",style: theme.textTheme.bodyMedium!.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),),
                            ),
                            Container(
                              width: Screens.width(context) * 0.65,
                              height: Screens.padingHeight(context) * 0.07,

                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     color: Colors.grey
                              //   )
                              // ),
                              child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal:
                                          Screens.width(context) * 0.01),
                                  // hintText: 'Email',
                                  labelText: 'Label Type',
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                                value: context
                                    .read<LabelPrintcontrller>()
                                    .lbelcode,
                                icon: Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                isExpanded: true,
                                onChanged: (val) {
                                  setState(() {
                                    context
                                        .read<LabelPrintcontrller>()
                                        .choosedType(val.toString());
                                  });
                                },
                                items: context
                                    .read<LabelPrintcontrller>()
                                    .testdata
                                    .map((e) {
                                  return DropdownMenuItem(
                                      value: "${e.name}",
                                      child:
                                          Container(child: Text("${e.name}")));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Screens.padingHeight(context) * 0.01,
                        ),
                        Row(
                          children: [
                            Container(
                              width: Screens.width(context) * 0.96,
                              // color: Colors.amber,
                              height: Screens.padingHeight(context) * 0.05,
                              // alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                  onPressed: () {}, child: Text("Print")),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                  top: Screens.padingHeight(context) * 0.08,
                  child: Visibility(
                      visible:
                          context.watch<LabelPrintcontrller>().serachitemcode,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Screens.width(context) * 0.05),
                        height: Screens.padingHeight(context) * 0.4,
                        width: Screens.width(context),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: context
                                .read<LabelPrintcontrller>()
                                .filteritemcodeelist
                                .length,
                            itemBuilder: (ContextM, ind) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    context
                                        .read<LabelPrintcontrller>()
                                        .checkitemcode(
                                            context
                                                .read<LabelPrintcontrller>()
                                                .filteritemcodeelist[ind]
                                                .itemCode
                                                .toString(),
                                            context);
                                    //  context.read<LabelPrintcontrller>().mycontroller[0].text =context.read<LabelPrintcontrller>().filteritemcodeelist[ind].itemCode.toString();
                                    // context.read<LabelPrintcontrller>(). serachitemcode=false;
                                    //  context.read<LabelPrintcontrller>().disableKeyBoard(context);
                                  });
                                },
                                child: Container(
                                  color: Colors.white,
                                  // padding: E,
                                  child: Column(
                                    children: [
                                      Text(
                                          "${context.read<LabelPrintcontrller>().filteritemcodeelist[ind].itemCode.toString()}"),
                                      Divider()
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
