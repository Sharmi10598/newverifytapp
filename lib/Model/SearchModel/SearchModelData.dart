import '../ScanPostModel/ScanPostDataaModel.dart';

class SearchScanDataPost {
  int? auditid;
  String? whscode;
  String? bincode;
  String? itemCode;
  String? serialbatch;
  double? quantity;
  String? stockstatus;
  String? notes;
  String? status;
  String? devicecode;
  String? scandatetime;
  int? ismanual;
  int? templateid;
  String? scanguid;
  String? errormsg;
  List<DispListData>? checklist;

  SearchScanDataPost(
      {this.auditid,
      this.bincode,
      this.scanguid,
      this.devicecode,
      this.ismanual,
      this.errormsg,
      this.itemCode,
      this.status,
      this.notes,
      this.quantity,
      this.scandatetime,
      this.serialbatch,
      this.stockstatus,
      this.checklist,
      this.templateid,
      this.whscode});
}
