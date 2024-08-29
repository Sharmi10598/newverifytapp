import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Controllers/AuditController/AuditControllers.dart';

class ScannerPage extends StatefulWidget {
  @override
  ScannerPageState createState() => ScannerPageState();
}

// callBinBlockApi
class ScannerPageState extends State<ScannerPage> {
  String? barcode;
  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  List<Barcode> barcodes = [];
  static bool bincodeScan = false;
  static bool batchCodeScan = false;
  static bool itemCodeScan = false;
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                barcodes = capture.barcodes;
                for (var barcode in barcodes) {
                  if (bincodeScan == true) {
                    log('barcode.rawValue::${barcode.rawValue}');
                    scanBinCode(theme, barcode.rawValue!);
                  } else if (batchCodeScan == true) {
                    log('Batch.rawValue::${barcode.rawValue}');
                    scanBatchCode(theme, barcode.rawValue!);
                  }
                  // else if (itemCodeScan == true) {
                  //   log('itemcode.rawValue::${barcode.rawValue}');
                  //   scanItemCode(theme, barcode.rawValue!);
                  // }
                }
              },
            ),
          ),
          // if (barcode != null)
          //   Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Text(
          //       'Barcode found: $barcode',
          //       style: const TextStyle(fontSize: 18),
          //     ),
          //   ),
        ],
      ),
    );
  }

// [log] linemaster itecode::001@
// [log] linemaster itecode::002 DRESSING TABLE
// [log] linemaster itecode::006 SIL dummy
// [log] linemaster itecode::006 SIL dummy item
// [log] linemaster itecode::006 SIL dummy item10
// [log] linemaster itecode::006 SIL dummy item11
// [log] linemaster itecode::006 SIL dummy item12
// [log] linemaster itecode::006 SIL dummy item120
// [log] linemaster itecode::006 SIL dummy item13
// [log] linemaster itecode::006 SIL dummy item14
  scanBinCode(ThemeData theme, String binValues) async {
    Navigator.pop(context);
    // BinCode Result::[{BinCode: B011}, {BinCode: B04}, {BinCode: B015}, {BinCode: B02}, {BinCode: B09}, {BinCode: B014}, {BinCode: B013},
    //s {BinCode: B020}, {BinCode: B019}, {BinCode: B02}]
    context
        .read<AuditCtrlProvider>()
        .afterScanbinCode(context, theme, 'BinCode', binValues);
    bincodeScan = false;
    // context.read<AuditCtrlProvider>().disableKeyBoard(context);
  }

  scanBatchCode(ThemeData theme, String binValues) {
    Navigator.pop(context);
    if (context.read<AuditCtrlProvider>().formkey[2].currentState!.validate()) {
      log('SerailBatchSerailBatchxx::$binValues');
      context.read<AuditCtrlProvider>().mycontroller[3].text = binValues;
      setState(() {
        context.read<AuditCtrlProvider>().afterScanSerialBatch(
              context,
              theme,
              binValues,
              // context.read<AuditCtrlProvider>().mycontroller[2].text
            );
        // context.read<AuditCtrlProvider>().bottomSheetafterscanserial(
        //       context,
        //       theme,
        //     );
      });
      batchCodeScan = false;
    }
  }
}
