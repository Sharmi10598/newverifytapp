import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../Constant/Configuration.dart';
import '../../../Constant/Screen.dart';
import '../../../Controllers/DataController/DataControllers.dart';

class DataScreenPage extends StatefulWidget {
  const DataScreenPage({super.key});

  @override
  State<DataScreenPage> createState() => _DataScreenPageState();
}

class _DataScreenPageState extends State<DataScreenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<Datactrls>().init(context);
    });
  }

  Config config = Config();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Column(
        children: [
          AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,

            centerTitle: true,
            automaticallyImplyLeading: false,
            // ignore: prefer_const_constructors
            title: Text('Data'),
          ),
          // Container(
          //   height: Screens.padingHeight(context),
          //   child: Center(
          //     child: Text('No data to load..!!!'),
          //   ),
          // )
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: Screens.padingHeight(context) * 0.02,
                  bottom: Screens.padingHeight(context) * 0.02,
                  right: Screens.width(context) * 0.04,
                  left: Screens.width(context) * 0.08),
              width: Screens.width(context),
              height: Screens.padingHeight(context) * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Item Master',
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    String mssgg =
                                        "Already item master related data are available in memory. Click 'Continue' to proceed with this data or 'OK' to download a new process.";
                                    context.read<Datactrls>().checkTableEmpty(
                                          context,
                                          theme,
                                          mssgg,
                                          'Item',
                                        );
                                  });
                                },
                                icon: Icon(Icons.delete, size: 25))
                          ],
                        ),
                        Container(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  foregroundColor: Colors.white,
                                  backgroundColor: theme.primaryColor),
                              onPressed: context
                                              .read<Datactrls>()
                                              .btnDisabled ==
                                          true ||
                                      context.read<Datactrls>().itemLength != 0
                                  ? null
                                  : () async {
                                      setState(() {
                                        context.read<Datactrls>().btnDisabled =
                                            true;
                                        context.read<Datactrls>().itemloading =
                                            true;
                                        context.read<Datactrls>().stockloading =
                                            false;
                                        context.read<Datactrls>().binloading =
                                            false;
                                        context
                                            .read<Datactrls>()
                                            .callGetItemMasterApi(
                                                context, theme);
                                        // .donwloadItemData();
                                      });
                                    },
                              child: context.watch<Datactrls>().itemloading ==
                                      true
                                  ? Center(
                                      child: SpinKitThreeBounce(
                                        size: Screens.padingHeight(context) *
                                            0.04,
                                        color: theme.primaryColor,
                                      ),
                                    )
                                  : Text('Download')),
                        ),
                        // Text('Loading icons will come'),
                        Text(
                            'No. of Records: ${context.watch<Datactrls>().itemLength}'),
                        Text(
                            'Last Downloaded Time : ${context.watch<Datactrls>().itemLastDownTime ?? ''}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.02,
                  ),
                  Container(
                    // width: Screens.width(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Stock Data',
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    String mssgg =
                                        "Already stock master related data are available in memory. Click 'Continue' to proceed with this data or 'OK' to downloada new process.";
                                    context.read<Datactrls>().checkTableEmpty(
                                          context,
                                          theme,
                                          mssgg,
                                          'Stock',
                                        );
                                  });
                                },
                                icon: Icon(Icons.delete, size: 25))
                          ],
                        ),

                        Form(
                          key: context.watch<Datactrls>().formKey,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // border: Border.all(color: Colors.black26)
                            ),
                            width: Screens.width(context) * 0.7,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 12.0),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Please Select Warehouse';
                                }
                                return null;
                              },
                              value:
                                  context.watch<Datactrls>().selectedStockValue,
                              hint: Text(context
                                          .watch<Datactrls>()
                                          .selectedStockValue ==
                                      null
                                  ? 'Select Warehouse'
                                  : ''),
                              items: context
                                  .watch<Datactrls>()
                                  .whsListDropData
                                  .map((label) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                          label.whsName!,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                        value: label.whsName,
                                      ))
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  context.read<Datactrls>().selectedStockValue =
                                      newValue!;
                                  context
                                      .read<Datactrls>()
                                      .selectStockWhsCode();
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Screens.padingHeight(context) * 0.005,
                        ),

                        Container(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  foregroundColor: Colors.white,
                                  backgroundColor: theme.primaryColor),
                              onPressed: context
                                              .read<Datactrls>()
                                              .btnDisabled ==
                                          true ||
                                      context.read<Datactrls>().stocklength != 0
                                  ? null
                                  : () async {
                                      setState(() {
                                        if (context
                                            .read<Datactrls>()
                                            .formKey
                                            .currentState!
                                            .validate()) {
                                          //

                                          context
                                              .read<Datactrls>()
                                              .btnDisabled = true;
                                          context
                                              .read<Datactrls>()
                                              .stockloading = true;
                                          context
                                              .read<Datactrls>()
                                              .itemloading = false;
                                          context.read<Datactrls>().binloading =
                                              false;

                                          context
                                              .read<Datactrls>()
                                              .callGettStocksMaster(
                                                  context, theme);
                                        }
                                        // else {
                                        //   context
                                        //       .read<Datactrls>()
                                        //       .apiResponseDialog(
                                        //           context,
                                        //           theme,
                                        //           'Please Select Warehouse');
                                        // }
                                        // .donwloadItemData();
                                      });
                                    },
                              child: context.watch<Datactrls>().stockloading ==
                                      true
                                  ? SpinKitThreeBounce(
                                      size:
                                          Screens.padingHeight(context) * 0.04,
                                      color: theme.primaryColor)
                                  : Text('Download')),
                        ),
                        // Text('Loading icons will come'),
                        Text(
                            'No. of Records: ${context.watch<Datactrls>().stocklength}'),
                        Text(
                            'Last Downloaded Time : ${context.watch<Datactrls>().stockLastDownTime ?? ''}'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.02,
                  ),
                  Container(
                    // width: Screens.width(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Bin Master',
                                style: theme.textTheme.bodyLarge!.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    String mssgg =
                                        "Already bin master related data are available in memory. Click 'Continue' to proceed with this data or 'OK' to downloada new process.";
                                    context.read<Datactrls>().checkTableEmpty(
                                          context,
                                          theme,
                                          mssgg,
                                          'Bin',
                                        );
                                  });
                                },
                                icon: Icon(Icons.delete, size: 25))
                          ],
                        ),
                        Container(
                          width: Screens.width(context) * 0.4,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  foregroundColor: Colors.white,
                                  backgroundColor: theme.primaryColor),
                              onPressed: context
                                              .read<Datactrls>()
                                              .btnDisabled ==
                                          true ||
                                      context.read<Datactrls>().binLength != 0
                                  ? null
                                  : () async {
                                      setState(() {
                                        context.read<Datactrls>().btnDisabled =
                                            true;
                                        context.read<Datactrls>().binloading =
                                            true;
                                        context.read<Datactrls>().itemloading =
                                            false;
                                        context.read<Datactrls>().stockloading =
                                            false;
                                        context
                                            .read<Datactrls>()
                                            .callGetBinMasterApi(
                                                context, theme);
                                        // .donwloadItemData();
                                      });
                                    },
                              child:
                                  context.watch<Datactrls>().binloading == true
                                      ? SpinKitThreeBounce(
                                          size: Screens.padingHeight(context) *
                                              0.04,
                                          color: theme.primaryColor)
                                      : Text('Download')),
                        ),

                        // Text('Loading icons will come'),
                        Text(
                            'No. of Records: ${context.watch<Datactrls>().binLength}'),
                        Text(
                          'Last Downloaded Time : ${context.watch<Datactrls>().binLastDownTime ?? ''}',
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
// Container(
//   padding: EdgeInsets.only(
//       top: Screens.padingHeight(context) * 0.02,
//       bottom: Screens.padingHeight(context) * 0.02,
//       right: Screens.width(context) * 0.02,
//       left: Screens.width(context) * 0.08),
//   height: Screens.padingHeight(context),
//   child: Column(
//     children: [
//       Container(
//         width: Screens.width(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Item Master',
//                 style: theme.textTheme.bodyLarge!
//                     .copyWith(fontSize: 16)),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     foregroundColor: Colors.white,
//                     backgroundColor: theme.primaryColor),
//                 onPressed: () async {},
//                 child: const Text(' Download ')),
//             Text('Loading icons will come'),
//             Text('No Of Recordes: '),
//             Text('Last Downloaded : '),
//           ],
//         ),
//       ),
//       SizedBox(
//         height: Screens.padingHeight(context) * 0.02,
//       ),
//       Container(
//         width: Screens.width(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Stocks Data',
//                 style: theme.textTheme.bodyLarge!
//                     .copyWith(fontSize: 16)),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     foregroundColor: Colors.white,
//                     backgroundColor: theme.primaryColor),
//                 onPressed: () async {},
//                 child: const Text(' Download ')),
//             Text('Loading icons will come'),
//             Text('No Of Recordes: '),
//             Text('Last Downloaded : '),
//           ],
//         ),
//       ),
//       SizedBox(
//         height: Screens.padingHeight(context) * 0.02,
//       ),
//       Container(
//         width: Screens.width(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Bin Master',
//                 style: theme.textTheme.bodyLarge!
//                     .copyWith(fontSize: 16)),
//             ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     foregroundColor: Colors.white,
//                     backgroundColor: theme.primaryColor),
//                 onPressed: () async {},
//                 child: const Text(' Download ')),
//             Text('Loading icons will come'),
//             Text('No Of Recordes: '),
//             Text('Last Downloaded : '),
//           ],
//         ),
//       ),
//     ],
//   ),
// )
