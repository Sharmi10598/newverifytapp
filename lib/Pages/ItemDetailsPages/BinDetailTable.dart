import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Model/ScanPostModel/ScanPostDataaModel.dart';

import '../../../Constant/Screen.dart';
import '../../../Controllers/AuditController/AuditControllers.dart';

class BinDetailstable extends StatefulWidget {
  BinDetailstable({Key? key, required this.tablerColumn}) : super(key: key);

  List<ScanDataPost> tablerColumn = [];

  @override
  State<BinDetailstable> createState() => _BinDetailstableState();
}

class _BinDetailstableState extends State<BinDetailstable> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    _generateColumns(List<ScanDataPost> valuesx) {
      List<DataColumn> columns = [];
      var data = valuesx.map((e) => e.toMap()).toList();
      columns = [
        DataColumn(
          label: Text('Serial Batch'),
        ),
        DataColumn(
          label: Text('Item Code'),
        ),
        DataColumn(
          label: Text('Quantity'),
        ),
        DataColumn(
          label: Text('Status'),
        ),
        DataColumn(
          label: Text('Notes'),
        ),
      ];

      // });
      return columns;
    }

    List<DataRow> _generateRows(List<ScanDataPost> data) {
      List<DataRow> rows = [];
      data.forEach((item) {
        List<DataCell> cells = [];
        cells.add(DataCell(Text(
          item.serialbatch.toString(),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        )));
        cells.add(DataCell(Text(item.itemCode.toString())));
        cells.add(DataCell(Text(item.quantity.toString())));
        cells.add(DataCell(Text(item.stockstatus.toString())));
        cells.add(DataCell(Text(item.notes.toString())));

        rows.add(DataRow(cells: cells));
      });
      return rows;
    }

    return context.watch<AuditCtrlProvider>().tableColumLoad == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: Screens.width(context),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        Screens.bodyheight(context) * 0.01),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400]!,
                          // blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: const Offset(2, 0))
                    ]),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DataTable(
                          // headingRowColor:  MaterialStateColor.resolveWith((states) => theme.primaryColor),
                          columnSpacing: 7.0,
                          headingRowHeight:
                              Screens.padingHeight(context) * 0.05,
                          dataRowHeight: Screens.padingHeight(context) * 0.045,
                          border: TableBorder.symmetric(
                              inside: BorderSide(
                                  color: theme.primaryColor.withOpacity(0.1))),
                          columns: _generateColumns(widget.tablerColumn),
                          rows: _generateRows(widget.tablerColumn),

                          headingTextStyle: theme.textTheme.bodyMedium!
                              .copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
            ],
          );
  }
}
