import 'dart:convert';
import 'package:verifytapp/Model/AuditModel/AuditActionModel.dart';

class GetAuditBinkModel {
  String respType;
  String respCode;
  String respDesc;
  int stsCode;
  List<BinMasterData> auditData;
  String exception;
  GetAuditBinkModel(
      {required this.exception,
      required this.respCode,
      required this.respDesc,
      required this.respType,
      required this.auditData,
      required this.stsCode});
  factory GetAuditBinkModel.fromJson(dynamic json, int statuzCode) {
    // Map<String, dynamic>
    if (statuzCode == 200) {
      var list = jsonDecode(json['data']) as List;
      List<BinMasterData> dataList =
          list.map((data) => BinMasterData.fromJson(data)).toList();

      return GetAuditBinkModel(
        exception: '',
        respCode: json['respCode'],
        respDesc: json['respDesc'],
        respType: json['respType'],
        stsCode: statuzCode,
        auditData: dataList,
      );
      // GetAuditActionMainDataModel.fromJson(json['data']));
    } else {
      return GetAuditBinkModel(
          exception: json['respDesc'],
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          auditData: []);
    }
  }

  factory GetAuditBinkModel.issue(
      int rescode, Map<String, dynamic> exp, int statuzCode) {
    return GetAuditBinkModel(
        exception: exp['respDesc'],
        respCode:exp['respCode'],
        respDesc: exp['respDesc'],
        respType: '',
        stsCode: statuzCode,
        auditData: []
        // data: []
        );
  }

  factory GetAuditBinkModel.issue2(
    int rescode,
    String exp,
  ) {
    return GetAuditBinkModel(
        exception: exp,
        respCode: '',
        respDesc: '',
        respType: '',
        stsCode: rescode,
        auditData: []
        // data: []
        );
  }

  factory GetAuditBinkModel.error(int rescode, String exp) {
    return GetAuditBinkModel(
        exception: exp,
        respCode: '',
        respDesc: '',
        respType: '',
        stsCode: rescode,
        auditData: []
        // data: []
        );
  }
}
