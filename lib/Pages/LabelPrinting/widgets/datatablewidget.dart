
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Constant/Screen.dart';
import 'package:verifytapp/Controllers/LebelprintController/LabelprintController.dart';
import 'package:verifytapp/Model/labelscanModel/LabelscandataModel.dart';

class labeltable extends StatefulWidget {
   labeltable({super.key,required this.getallLabelscandata});

  List<Labelscandata> getallLabelscandata=[];
  @override
  State<labeltable> createState() => _labeltableState();
}

class _labeltableState extends State<labeltable> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    _generateColumns(List<Labelscandata> valuesx) {
      List<DataColumn> columns = [];
      // var data = valuesx.map((e) => e.toMap()).toList();
      columns = [
        DataColumn(
          label: Text('Serial No'),
        ),
        
        DataColumn(
          label: Text('Quantity'),
        ),
     
      ];

      // });
      return columns;
    }

    List<DataRow> _generateRows(List<Labelscandata> data) {
      List<DataRow> rows = [];
      data.forEach((item) {
        List<DataCell> cells = [];
        cells.add(DataCell(Text(
          item.serialNo.toString(),
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        )));
       
        cells.add(DataCell(Container(
          width: Screens.width(context)*0.20,
          alignment: Alignment.center,
          child: Text(
            item.quantity.toString().replaceAll('.0', ''),
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          ),
        )));
        
        rows.add(DataRow(cells: cells));
      });
      return rows;
    }
    return       context.watch<LabelPrintcontrller>().tableColumLoad == true
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            ),
          )
        : Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: Screens.width(context),
                // height: Screens.padingHeight(context)*0.55,
                padding: EdgeInsets.symmetric(
                  horizontal: Screens.width(context)*0.03
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                        Screens.bodyheight(context) * 0.01),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300]!,
                          // blurRadius: 2.0,
                          spreadRadius: 1.0,
                          offset: const Offset(2, 0))
                    ]),
                child: SingleChildScrollView(
                   physics: const BouncingScrollPhysics(),
                  child: SingleChildScrollView(
                       physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DataTable(
                            // headingRowColor:  MaterialStateColor.resolveWith((states) => theme.primaryColor),
                            columnSpacing: 50.0,
                            headingRowHeight:
                                Screens.padingHeight(context) * 0.05,
                            dataRowHeight: Screens.padingHeight(context) * 0.045,
                            border: TableBorder.symmetric(
                                inside: BorderSide(
                                    color: theme.primaryColor.withOpacity(0.1))),
                            columns: _generateColumns(widget.getallLabelscandata),
                            rows: _generateRows(widget.getallLabelscandata),
                  
                            headingTextStyle: theme.textTheme.bodyMedium!
                                .copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          );

  }
}