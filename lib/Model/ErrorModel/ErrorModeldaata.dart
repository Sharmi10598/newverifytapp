import '../../DBModel/ScanDataPostDB/ScannedErrorTable.dart';
import '../ScanPostModel/ScanPostDataaModel.dart';

class ErrorScanDataPost {
  int? auditid;
  String? whscode;
  String? bincode;
  String? itemCode;
  String? serialbatch;
  double? quantity;
  String? stockstatus;
  String? notes;
  String? devicecode;
  String? scandatetime;
  int? ismanual;
  int? templateid;
  String? scanguid;
  String? errormsg;
  List<DispListData>? checklist;

  ErrorScanDataPost(
      {required this.auditid,
      required this.bincode,
      required this.scanguid,
      required this.devicecode,
      required this.ismanual,
      required this.errormsg,
      required this.itemCode,
      required this.notes,
      required this.quantity,
      required this.scandatetime,
      required this.serialbatch,
      required this.stockstatus,
      required this.checklist,
      required this.templateid,
      required this.whscode});
  Map<String, dynamic> tojson() {
    Map<String, dynamic> data = <String, dynamic>{
      "auditid": auditid,
      "whscode": whscode,
      "bincode": bincode,
      "itemcode": itemCode,
      "serialbatch": serialbatch,
      "quantity": quantity,
      "stockstatus": stockstatus,
      "notes": notes,
      "devicecode": devicecode,
      "scandatetime": scandatetime,
      "ismanual": ismanual,
      "templateid": templateid,
      "scanguid": scanguid,
      "checklist": checklist!.map((e) => e.toMap()).toList(),
    };
    return data;
  }

  Map<String, Object?> toMapErrors() => {
        ErrorScanTableDBT.auditid: auditid,
        ErrorScanTableDBT.bincode: bincode,
        ErrorScanTableDBT.devicecode: devicecode,
        ErrorScanTableDBT.ismanual: ismanual,
        ErrorScanTableDBT.itemCode: itemCode,
        ErrorScanTableDBT.quantity: quantity,
        ErrorScanTableDBT.notes: notes,
        ErrorScanTableDBT.scandatetime: scandatetime,
        ErrorScanTableDBT.serialbatch: serialbatch,
        ErrorScanTableDBT.stockstatus: stockstatus,
        ErrorScanTableDBT.templateid: templateid,
        ErrorScanTableDBT.whscode: whscode,
        ErrorScanTableDBT.scanguid: scanguid,
        ErrorScanTableDBT.apiErrorMsg: errormsg,
      };
}
