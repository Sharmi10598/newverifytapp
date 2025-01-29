// {
//     "respType": "Success",
//     "respCode": "WS100",
//     "respDesc": "Data retriaved successfully",
//     "data": "[{\"Id\":1,\"Customer_Id\":3,\"Service\":\"Setup\",\"ServiceUrl\":\"http://dev.sellerkit.in:5451\"},{\"Id\":4,\"Customer_Id\":3,\"Service\":\"Audit\",\"ServiceUrl\":\"http://dev.sellerkit.in:5452\"},{\"Id\":5,\"Customer_Id\":3,\"Service\":\"Logistics\",\"ServiceUrl\":\"http://dev.sellerkit.in:5460\"},{\"Id\":6,\"Customer_Id\":3,\"Service\":\"Operations\",\"ServiceUrl\":\"http://dev.sellerkit.in:5456\"},{\"Id\":7,\"Customer_Id\":3,\"Service\":\"Planning\",\"ServiceUrl\":\"sdf\"}]"
// }
import 'dart:convert';

class GetUrlModel {
  String message;
  bool? status;
  String? exception;
  List<GetUrlModelData> urlData;
  int? stcode;
  GetUrlModel(
      {required this.message,
      required this.status,
      this.exception,
      required this.urlData,
      required this.stcode});
  factory GetUrlModel.fromJson(Map<String, dynamic> jsons, int stcode) {
    if (jsons['data'] != null) {
      // log('message::${jsonDecode(json['data'])}');
      var list = jsonDecode(jsons['data']) as List;
      List<GetUrlModelData> dataList =
          list.map((data) => GetUrlModelData.fromJson(data)).toList();

      return GetUrlModel(
        message: "sucess",
        status: true,
        urlData: dataList,
        stcode: stcode,
        exception: null,
      );
    } else {
      return GetUrlModel(
          urlData: [],
          message: "failed",
          status: false,
          stcode: stcode,
          exception: null);
    }
  }
  factory GetUrlModel.issue(int rescode, String exp) {
    return GetUrlModel(
      urlData: [],
      message: 'Exception',
      status: null,
      stcode: rescode,
      exception: exp,
    );
  }

  factory GetUrlModel.error(String jsons, int stcode) {
    return GetUrlModel(
        urlData: [],
        message: 'Catch',
        status: null,
        stcode: stcode,
        exception: jsons);
  }
}

class GetUrlModelData {
  int id;
  int? custId;
  String? Service;
  String? type;
  String? ServiceUrl;

  GetUrlModelData({
    required this.id,
    required this.type,
    required this.custId,
    required this.Service,
    required this.ServiceUrl,
  });
// {\"Id\":1,\"Customer_Id\":3,\"Service\":\"Setup\",\"ServiceUrl\":\"http://dev.sellerkit.in:5451\"}
  factory GetUrlModelData.fromJson(Map<String, dynamic> jsons) {
    return GetUrlModelData(
      type: jsons['Type'] != null ? jsons['Type'].toString() : '',
      id: jsons['Id'] != null ? jsons['Id'] : 0,
      custId: jsons['Customer_Id'] ?? 0,
      Service: jsons['Service'] != null ? jsons['Service'].toString() : '',
      ServiceUrl:
          jsons['ServiceUrl'] != null ? jsons['ServiceUrl'].toString() : '',
    );
  }
}
