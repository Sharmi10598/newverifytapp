// Status	INTEGER,
// hasExpiryDate	TEXT,
// PreviousDispute	TEXT,
// SerialBatchManualTyped	TEXT,
// WhileOffline	TEXT,
import 'package:flutter/material.dart';

class CheckListMasterModel {
  int docEntry;
  String whsCode;
  String whsName;
  String zoneCode;
  String rackCode;
  String areaCode;
  String binCode;
  String itemCode;
  String category;
  String brand;
  String subCategory;
  String specification;
  String sizeCapacity;
  Text hasExpiryDate;
  int isFragile;
  String manageBy;
  String itemStatus;
  String serialBatch;
  String disposition;
  bool whileOffline;
  int forAgesAbove;
  bool serialBatchManualTyped;
  bool previousDispute;
  int checklistTemplate;
  int status;
  int createdBy;
  String createdDateTime;
  String updatedBy;
  String updatedDateTime;
  String traceid;

  CheckListMasterModel(
      {required this.areaCode,
      required this.binCode,
      required this.brand,
      required this.category,
      required this.rackCode,
      required this.createdBy,
      required this.createdDateTime,
      required this.checklistTemplate,
      required this.disposition,
      required this.docEntry,
      required this.forAgesAbove,
      required this.hasExpiryDate,
      required this.isFragile,
      required this.itemCode,
      required this.itemStatus,
      required this.manageBy,
      required this.previousDispute,
      required this.serialBatch,
      required this.serialBatchManualTyped,
      required this.sizeCapacity,
      required this.specification,
      required this.status,
      required this.subCategory,
      required this.traceid,
      required this.updatedBy,
      required this.updatedDateTime,
      required this.whileOffline,
      required this.whsCode,
      required this.whsName,
      required this.zoneCode});
// {\"DocEntry\":1,\"WhsCode\":\"W001\",\"AreaCode\":\"Area00999\",\"ZoneCode\":\"Z001\",\"RackCode\":\"R001\",\
//"BinCode\":\"767\",\"ItemCode\":\"006 SIL dummy item12\",\"Brand\":\"20577\",\"Category\":\"4\",\"SubCategory\":\"3\",
//\"Specification\":\"t\",\"SizeCapacity\":\"5L\",\"hasExpiryDate\":null,\"isFragile\":null,\"ManageBy\":null,
//\"ItemStatus\":\"t\",\"SerialBatch\":\"All\",\"Disposition\":\"1\",\"WhileOffline\":true,\"ForAgesAbove\":2,
//\"SerialBatch_ManualTyped\":true,\"Previous_Dispute\":null,\"Checklist_Template\":14,\"Status\":false,\"CreatedBy\":1,
//\"CreatedDateTime\":\"2024-08-13T19:03:06.023\",\"UpdatedBy\":\"1\",\"UpdatedDateTime\":\"2024-08-13T19:03:06.023\",
//\"traceid\":\"12d14806-7afb-4785-aa81-96e7d86e2d44\",\"WhsName\":\"TEST\"},
  factory CheckListMasterModel.fromJson(Map<String, dynamic> json) {
    return CheckListMasterModel(
      areaCode: json['AreaCode'].toString() ?? '',
      rackCode: json['RackCode'].toString() ?? '',
      binCode: json['BinCode'] ?? '',
      brand: json['Brand'] ?? '',
      category: json['Category'] ?? '',
      createdBy: json['CreatedBy'] ?? 0,
      createdDateTime: json['CreatedDateTime'] ?? '',
      checklistTemplate: json['Checklist_Template'] ?? 0,
      disposition: json['Disposition'] ?? '',
      docEntry: json['DocEntry'] ?? 0,
      forAgesAbove: json['ForAgesAbove'] ?? 0,
      hasExpiryDate: json['hasExpiryDate'] ?? false,
      isFragile: json['isFragile'] ?? 0,
      itemCode: json['ItemCode'] ?? '',
      itemStatus: json['ItemStatus'] ?? '',
      manageBy: json['ManageBy'] ?? '',
      previousDispute: json['Previous_Dispute'] ?? false,
      serialBatch: json['SerialBatch'] ?? '',
      serialBatchManualTyped: json['SerialBatch_ManualTyped'] ?? false,
      sizeCapacity: json['SizeCapacity'] ?? '',
      specification: json['Specification'] ?? '',
      status: json['Status'] ?? false,
      subCategory: json['SubCategory'] ?? '',
      traceid: json['traceid'] ?? '',
      updatedBy: json['UpdatedBy'] ?? '',
      updatedDateTime: json['UpdatedDateTime'] ?? '',
      whileOffline: json['WhileOffline'] ?? false,
      whsCode: json['WhsCode'] ?? '',
      whsName: json['WhsName'] ?? '',
      zoneCode: json['ZoneCode'] ?? '',
    );
  }
}
