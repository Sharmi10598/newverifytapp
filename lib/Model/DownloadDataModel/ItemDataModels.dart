import 'dart:convert';
import 'package:verifytapp/Model/AuditModel/AuditActionModel.dart';

class GetAuditItemModel {
  String respType;
  String respCode;
  String respDesc;
  int stsCode;
  List<HeaderData> auditItemData;

  String exception;
  GetAuditItemModel(
      {required this.exception,
      required this.respCode,
      required this.respDesc,
      required this.respType,
      required this.auditItemData,
      required this.stsCode});
  factory GetAuditItemModel.fromJson(dynamic json, int statuzCode) {
    // Map<String, dynamic>
    if (statuzCode == 200) {
      var list = jsonDecode(json['data']) as List;
      List<HeaderData> dataList =
          list.map((data) => HeaderData.fromJson(data)).toList();

      return GetAuditItemModel(
        exception: '',
        respCode: json['respCode'],
        respDesc: json['respDesc'],
        respType: json['respType'],
        stsCode: statuzCode,
        auditItemData: dataList,
      );
      // GetAuditActionMainDataModel.fromJson(json['data']));
    } else {
      return GetAuditItemModel(
          exception: json['respDesc'],
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          auditItemData: []);
    }
  }

  factory GetAuditItemModel.issue(
     Map<String, dynamic> exp, int statuzCode) {
    return GetAuditItemModel(
        exception: exp['respDesc'],
        respCode: exp['respCode'],
        respDesc: exp['respDesc'],
        respType: '',
        stsCode: statuzCode,
        auditItemData: []);
  }

  factory GetAuditItemModel.issue2(
    int rescode,
    String exp,
  ) {
    return GetAuditItemModel(
        exception: exp,
        respCode: '',
        respDesc: '',
        respType: '',
        stsCode: rescode,
        auditItemData: []
        // data: []
        );
  }

  factory GetAuditItemModel.error(int rescode, String exp) {
    return GetAuditItemModel(
        exception: exp,
        respCode: '',
        respDesc: '',
        respType: '',
        stsCode: rescode,
        auditItemData: []);
  }
}
