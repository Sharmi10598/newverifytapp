
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/Screen.dart';
import '../../../Controllers/AuditController/AuditControllers.dart';
import '../../../Model/ErrorModel/ErrorModeldaata.dart';

class DataTableErrorWidget extends StatefulWidget {
  DataTableErrorWidget({Key? key, required this.tablerColumn}) : super(key: key);

  List<ErrorScanDataPost> tablerColumn = [];

  @override
  State<DataTableErrorWidget> createState() => _DataTableErrorWidgetState();
}

class _DataTableErrorWidgetState extends State<DataTableErrorWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    List<DataColumn> _generateColumns(List<ErrorScanDataPost> valuesx) {
      List<DataColumn> columns = [];
      var data = valuesx.map((e) => e.toMapErrors()).toList();
      // log('yyyyyyyyyyyyyyyykey::${data.first.keys.length}');

      data.first.keys.forEach((key) {
        columns.add(DataColumn(
          label: Text(key),
        ));
      });
      return columns;
    }

    List<DataRow> _generateRows(List<ErrorScanDataPost> data) {
      List<DataRow> rows = [];
      // log('xxxxkey::${item!.length}');

      data.forEach((item) {
        // log('xxxxxxxxxxxxxxx::${data.length}');

        List<DataCell> cells = [];
        // item.forEach((key) {
        // cells.add(DataCell(Text(item.localid.toString())));
        cells.add(DataCell(Text(item.auditid.toString())));
        cells.add(DataCell(Text(item.bincode.toString())));
        cells.add(DataCell(Text(item.devicecode.toString())));
        cells.add(DataCell(Text(item.ismanual.toString())));
        cells.add(DataCell(Text(item.itemCode.toString())));
        cells.add(DataCell(Text(item.quantity.toString())));
        cells.add(DataCell(Text(item.notes.toString())));
        cells.add(DataCell(Text(item.scandatetime.toString())));
        cells.add(DataCell(Text(item.serialbatch.toString())));
        cells.add(DataCell(Text(item.stockstatus.toString())));
        cells.add(DataCell(Text(item.templateid.toString())));
        cells.add(DataCell(Text(item.whscode.toString())));
        cells.add(DataCell(Text(item.scanguid.toString())));
        cells.add(DataCell(Text(item.errormsg.toString())));
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
                width: Screens.width(context) * 0.95,
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
                         headingRowHeight: Screens.padingHeight(context)*0.05,
                          dataRowHeight:  Screens.padingHeight(context)*0.045,
                          columnSpacing: 7.0,
                          border: TableBorder.symmetric(
                              inside: BorderSide(
                                  color: theme.primaryColor.withOpacity(0.1))),
                          // sortColumnIndex: 1,
                          columns: _generateColumns(widget.tablerColumn),
                          rows: _generateRows(widget.tablerColumn),

                          headingTextStyle: theme.textTheme.bodyMedium!
                              .copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                        // SizedBox(height: Screens.bodyheight(context) * 0.1)
                      ],
                    )),
              ),
            ],
          );
  }
}
