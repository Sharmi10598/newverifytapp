import 'dart:convert';

class GetCheckListnMaster {
  String respType;
  String respCode;
  String respDesc;
  int stsCode;
  List<CheckListMasterModel>? listData;

  String exception;
  GetCheckListnMaster(
      {required this.exception,
      required this.respCode,
      required this.respDesc,
      required this.respType,
      required this.listData,
      required this.stsCode});
  factory GetCheckListnMaster.fromJson(dynamic json, int statuzCode) {
    // Map<String, dynamic>
    if (statuzCode == 200) {
      var list = jsonDecode(json['data']) as List;
      List<CheckListMasterModel> dataList =
          list.map((data) => CheckListMasterModel.fromJson(data)).toList();

      return GetCheckListnMaster(
          exception: '',
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          listData: dataList
          // GetAuditActionMainDataModel.fromJson(jsonDecode(json['data'])
          // ),
          );
      // GetAuditActionMainDataModel.fromJson(json['data']));
    } else {
      return GetCheckListnMaster(
          exception: json['respDesc'],
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          listData: null);
    }
  }

  factory GetCheckListnMaster.issue(
      int rescode, Map<String, dynamic> exp, int statuzCode) {
    return GetCheckListnMaster(
        exception: exp['respDesc'],
        respCode: exp['respCode'],
        respDesc: '',
        respType: '',
        stsCode: statuzCode,
        listData: null
        // data: null
        );
  }

  factory GetCheckListnMaster.issue2(
    int rescode,
    String exp,
  ) {
    return GetCheckListnMaster(
        exception: exp,
        respCode: '',
        respDesc: '',
        respType: '',
        stsCode: rescode,
        listData: null
        // data: null
        );
  }

  factory GetCheckListnMaster.error(int rescode, String exp) {
    return GetCheckListnMaster(
        exception: exp,
        respCode: '',
        respDesc: '',
        respType: '',
        stsCode: rescode,
        listData: null
        // data: null
        );
  }
}

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
  String hasExpiryDate;
  int isFragile;
  String manageBy;
  String itemStatus;
  String serialBatch;
  String disposition;
  String whileOffline;
  int forAgesAbove;
  String serialBatchManualTyped;
  String previousDispute;
  int checklistTemplate;
  int status;
  int createdBy;
  String createdDateTime;
  String updatedBy;
  String updatedDateTime;
  String traceid;
//PreviousDispute
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
      hasExpiryDate: json['hasExpiryDate'] == true ? '1' : '0',
      isFragile: json['isFragile'] ?? 0,
      itemCode: json['ItemCode'] ?? '',
      itemStatus: json['ItemStatus'] ?? '',
      manageBy: json['ManageBy'] ?? '',
      previousDispute: json['Previous_Dispute'] == true ? '1' : '0',
      serialBatch: json['SerialBatch'] ?? '',
      serialBatchManualTyped:
          json['SerialBatch_ManualTyped'] == true ? '1' : '0',
      sizeCapacity: json['SizeCapacity'] ?? '',
      specification: json['Specification'] ?? '',
      status: json['Status'] == true ? 1 : 0,
      subCategory: json['SubCategory'] ?? '',
      traceid: json['traceid'] ?? '',
      updatedBy: json['UpdatedBy'] ?? '',
      updatedDateTime: json['UpdatedDateTime'] ?? '',
      whileOffline: json['WhileOffline'] == true ? '1' : '0',
      whsCode: json['WhsCode'] ?? '',
      whsName: json['WhsName'] ?? '',
      zoneCode: json['ZoneCode'] ?? '',
    );
  }
}
