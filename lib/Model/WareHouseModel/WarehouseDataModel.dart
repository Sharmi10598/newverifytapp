import 'dart:convert';

import '../../DBModel/WarehouseDB/WarehouseTDB.dart';

class WarehouseModel {
  String respType;
  String respCode;
  String respDesc;
  int stsCode;
  List<WareHouseListData> whsListData;
  String exception;
  WarehouseModel(
      {required this.exception,
      required this.respCode,
      required this.respDesc,
      required this.respType,
      required this.whsListData,
      required this.stsCode});
  factory WarehouseModel.fromJson(dynamic json, int statuzCode) {
    // Map<String, dynamic>
    if (statuzCode == 200) {
      var list = jsonDecode(json['data']) as List;
      List<WareHouseListData> dataList =
          list.map((data) => WareHouseListData.fromJson(data)).toList();

      return WarehouseModel(
        exception: '',
        respCode: json['respCode'],
        respDesc: json['respDesc'],
        respType: json['respType'],
        stsCode: statuzCode,
        whsListData: dataList,
      );
      // GetAuditActionMainDataModel.fromJson(json['data']));
    } else {
      return WarehouseModel(
          exception: json['respDesc'],
          respCode: json['respCode'],
          respDesc: json['respDesc'],
          respType: json['respType'],
          stsCode: statuzCode,
          whsListData: []);
    }
  }

  factory WarehouseModel.issue(
      int rescode, Map<String, dynamic> exp, int statuzCode) {
    return WarehouseModel(
        exception: exp['respDesc'],
        respCode: exp['respCode'],
        respDesc: exp['respCode'],
        respType: '',
        stsCode: statuzCode,
        whsListData: []
        );
  }

  factory WarehouseModel.issue2(
    int rescode,
    String exp,
  ) {
    return WarehouseModel(
        exception: exp,
        respCode: '',
        respDesc: exp,
        respType: '',
        stsCode: rescode,
        whsListData: []
        // data: []
        );
  }

  factory WarehouseModel.error(int rescode, String exp) {
    return WarehouseModel(
        exception: exp,
        respCode: '',
        respDesc: exp,
        respType: '',
        stsCode: rescode,
        whsListData: []
        // data: []
        );
  }
}

class WareHouseListData {
  String? whsCode;
  String? whsName;
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? state;
  String? country;
  String? picode;
  int? status;
  String? gstNo;
  String? primaryContact;
  String? primaryEmail;
  String? lotitude;
  String? longitude;
  int? createdBy;
  String? createdOn;
  int? updatedBy;
  String? updatedOn;
  String? traceid;
  WareHouseListData(
      {this.address1,
      this.address2,
      this.address3,
      this.city,
      this.country,
      this.createdBy,
      this.createdOn,
      this.gstNo,
      this.longitude,
      this.lotitude,
      this.picode,
      this.primaryContact,
      this.primaryEmail,
      this.state,
      this.status,
      this.traceid,
      this.updatedBy,
      this.updatedOn,
      this.whsCode,
      this.whsName});
  factory WareHouseListData.fromJson(Map<String, dynamic> json) {
// {\"WhsCode\":\"BS002\",\"WhsName\":\"North\",\"Address1\":\"72\",
//\"Address2\":\"nethaji street\",\"Address3\":\"gandhipuram\",\"City\":\"cbe\",\"State\":\"TN\",
//\"Country\":\"IN\",\"PinCode\":\"645120\",\"Status\":1,\"GSTNo\":\"22AAAAA0000A1Z5\",
//\"PrimaryContact\":\"7845123000\",\"PrimaryEmail\":\"ssh@gmail.com\",\"Latitude\":\"112\",
//\"Longitude\":\"26\",\"CreatedBy\":1,\"CreatedOn\":\"2024-08-06T18:43:51.277\",
//\"UpdatedBy\":1,\"UpdatedOn\":\"2024-08-06T18:44:30.44\",
//\"traceid\":\"0851ed88-374f-4ce5-a23b-d589984a0e9a\"}
    return WareHouseListData(
        address1: json['Address1'] ?? '',
        address2: json['Address2'] ?? '',
        address3: json['Address3'] ?? '',
        city: json['City'] ?? '',
        country: json['Country'] ?? '',
        createdBy: json['CreatedBy'] ?? 0,
        createdOn: json['CreatedOn'] ?? '',
        gstNo: json['GSTNo'] ?? '',
        longitude: json['Longitude'] ?? '',
        lotitude: json['Latitude'] ?? '',
        picode: json['Picode'] ?? '',
        primaryContact: json['PrimaryContact'] ?? '',
        primaryEmail: json['PrimaryEmail'] ?? '',
        state: json['State'] ?? '',
        status: json['Status'] ?? 0,
        traceid: json['traceid'] ?? '',
        updatedBy: json['UpdatedBy'] ?? 0,
        updatedOn: json['UpdatedOn'] ?? '',
        whsCode: json['WhsCode'] ?? '',
        whsName: json['WhsName'] ?? '');
  }
  Map<String, Object?> toMap() => {
        WarehouseDBTable.whsCode: whsCode,
        WarehouseDBTable.whsName: whsName,
        WarehouseDBTable.address1: address1,
        WarehouseDBTable.address2: address2,
        WarehouseDBTable.address3: address3,
        WarehouseDBTable.city: city,
        WarehouseDBTable.country: country,
        WarehouseDBTable.gstNo: gstNo,
        WarehouseDBTable.state: state,
        WarehouseDBTable.status: status,
        WarehouseDBTable.picode: picode,
        WarehouseDBTable.primaryContact: primaryContact,
        WarehouseDBTable.primaryEmail: primaryEmail,
        WarehouseDBTable.latitude: lotitude,
        WarehouseDBTable.longitude: longitude,
        WarehouseDBTable.traceid: traceid,
        WarehouseDBTable.createdBy: createdBy,
        WarehouseDBTable.createdOn: createdOn,
        WarehouseDBTable.updatedBy: updatedBy,
        WarehouseDBTable.updatedOn: updatedOn,
      };
}
