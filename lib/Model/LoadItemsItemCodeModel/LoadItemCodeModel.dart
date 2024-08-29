import 'dart:convert';
import 'package:verifytapp/Model/AuditModel/AuditActionModel.dart';

class GetItemCodeModel {
  String respType;
  String respCode;
  String respDesc;
  int stsCode;
  List<LoadItemCodeLists> auditData;
  String exception;
  GetItemCodeModel(
      {required this.exception,
      required this.respCode,
      required this.respDesc,
      required this.respType,
      required this.auditData,
      required this.stsCode});
  factory GetItemCodeModel.fromJson(dynamic json, int statuzCode) {
    // Map<String, dynamic>
    if (statuzCode == 200) {
      var list = jsonDecode(json['data']) as List;
      List<LoadItemCodeLists> dataList =
          list.map((data) => LoadItemCodeLists.fromJson(data)).toList();

      return GetItemCodeModel(
        exception: '',
        respCode: json['respCode'],
        respDesc: json['respDesc'],
        respType: json['respType'],
        stsCode: statuzCode,
        auditData: dataList,
      );
      // GetAuditActionMainDataModel.fromJson(json['data']));
    } else {
      return GetItemCodeModel(
          exception: json['respDesc'],
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          auditData: []);
    }
  }

  factory GetItemCodeModel.issue(
      int rescode, Map<String, dynamic> exp, int statuzCode) {
    return GetItemCodeModel(
        exception: exp['respDesc'],
        respCode: exp['respCode'],
        respDesc: exp['respDesc'],
        respType: '',
        stsCode: statuzCode,
        auditData: []
        // data: []
        );
  }

  factory GetItemCodeModel.issue2(
    int rescode,
    String exp,
  ) {
    return GetItemCodeModel(
        exception: exp,
        respCode: '',
        respDesc: exp,
        respType: '',
        stsCode: rescode,
        auditData: []
        // data: []
        );
  }

  factory GetItemCodeModel.error(int rescode, String exp) {
    return GetItemCodeModel(
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

class LoadItemCodeLists {
// "[{\"AuditSchedule_ID\":134,\"ItemCode\":\"002 DRESSING TABLE\",\"ManageBy\":\"S\",\"DispID\":3}]"

  int auditScheduleID;
  String itemCode;
  String manageBy;
  int dispID;

  LoadItemCodeLists({
    required this.auditScheduleID,
    required this.itemCode,
    required this.dispID,
    required this.manageBy,
  });

  factory LoadItemCodeLists.fromJson(Map<String, dynamic> jsons) {
    // log("gggg::" + jsons.length.toString() + "hhh" + jsons['Id'].toString());
    return LoadItemCodeLists(
      auditScheduleID: jsons['AuditSchedule_ID'],
      itemCode: jsons['ItemCode'] ?? '',
      manageBy: jsons['ManageBy'] ?? '',
      dispID: jsons['DispID'] ?? 0,
    );
  }

  // Map<String, Object?> toMap() => {
  //       HeaderTableDB.auditScheduleID: auditScheduleID,
  //       HeaderTableDB.id: id,
  //       HeaderTableDB.itemName: itemName,
  //       HeaderTableDB.itemCode: itemCode,
  //       HeaderTableDB.itemType: itemType,
  //       HeaderTableDB.brand: brand,
  //       HeaderTableDB.category: category,
  //       HeaderTableDB.subCategory: subCategory,
  //       HeaderTableDB.itemDescription: itemDescription,
  //       HeaderTableDB.modelNo: modelNo,
  //       HeaderTableDB.partCode: partCode,
  //       HeaderTableDB.sKUCode: sKUCode,
  //       HeaderTableDB.brandCode: brandCode,
  //       HeaderTableDB.itemGroup: itemGroup,
  //       HeaderTableDB.specification: specification,
  //       HeaderTableDB.sizeCapacity: sizeCapacity,
  //       HeaderTableDB.color: color,
  //       HeaderTableDB.clasification: clasification,
  //       HeaderTableDB.uoM: uoM,
  //       HeaderTableDB.length: length,
  //       HeaderTableDB.width: width,
  //       HeaderTableDB.height: height,
  //       HeaderTableDB.weight: weight,
  //       HeaderTableDB.volume: volume,
  //       HeaderTableDB.inwardUoM: inwardUoM,
  //       HeaderTableDB.inwardPackQty: inwardPackQty,
  //       HeaderTableDB.outwardUoM: outwardUoM,
  //       HeaderTableDB.outwardPackQty: outwardPackQty,
  //       HeaderTableDB.isPerishable: isPerishable,
  //       HeaderTableDB.hasExpiryDate: hasExpiryDate,
  //       HeaderTableDB.expiryDays: expiryDays,
  //       HeaderTableDB.isFragile: isFragile,
  //       HeaderTableDB.taxRate: taxRate,
  //       HeaderTableDB.textNote: textNote,
  //       HeaderTableDB.movingType: movingType,
  //       HeaderTableDB.manageBy: manageBy,
  //       HeaderTableDB.imageURL: imageURL,
  //       HeaderTableDB.status: status,
  //       HeaderTableDB.createdBy: createdBy,
  //       HeaderTableDB.createdDateTime: createdDateTime,
  //       HeaderTableDB.updatedBy: updatedBy,
  //       HeaderTableDB.updatedDateTime: updatedDateTime,
  //       HeaderTableDB.traceid: traceid,
  //     };
}
