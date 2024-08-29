import 'dart:convert';
import 'package:verifytapp/Model/AuditModel/AuditActionModel.dart';

class GetAuditStocksModel {
  String respType;
  String respCode;
  String respDesc;
  int stsCode;
  List<LineData> auditData;
  String exception;
  GetAuditStocksModel(
      {required this.exception,
      required this.respCode,
      required this.respDesc,
      required this.respType,
      required this.auditData,
      required this.stsCode});
  factory GetAuditStocksModel.fromJson(dynamic json, int statuzCode) {
    // Map<String, dynamic>
    if (statuzCode == 200) {
      var list = jsonDecode(json['data']) as List;
      List<LineData> dataList =
          list.map((data) => LineData.fromJson(data)).toList();

      return GetAuditStocksModel(
        exception: '',
        respCode: json['respCode'],
        respDesc: json['respDesc'],
        respType: json['respType'],
        stsCode: statuzCode,
        auditData: dataList,
      );
      // GetAuditActionMainDataModel.fromJson(json['data']));
    } else {
      return GetAuditStocksModel(
          exception: json['respDesc'],
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          auditData: []);
    }
  }

  factory GetAuditStocksModel.issue(
      int rescode, Map<String, dynamic> exp, int statuzCode) {
    return GetAuditStocksModel(
        exception: exp['respDesc'],
        respCode: exp['respCode'],
        respDesc: exp['respDesc'],
        respType: '',
        stsCode: statuzCode,
        auditData: []
        // data: []
        );
  }

  factory GetAuditStocksModel.issue2(
    int rescode,
    String exp,
  ) {
    return GetAuditStocksModel(
        exception: exp,
        respCode: '',
        respDesc: exp,
        respType: '',
        stsCode: rescode,
        auditData: []
        // data: []
        );
  }

  factory GetAuditStocksModel.error(int rescode, String exp) {
    return GetAuditStocksModel(
        exception: exp,
        respCode: '',
        respDesc: exp,
        respType: '',
        stsCode: rescode,
        auditData: []
        // data: []
        );
  }
}
