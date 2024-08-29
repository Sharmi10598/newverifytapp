// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_new, non_constant_identifier_names, unnecessary_string_interpolations, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:verifytapp/Model/ScanPostModel/ScanPostDataaModel.dart';
import '../../Constant/ConstantSapValues.dart';

import '../../Constant/LocalUrl/GetLocalUrl.dart';
import '../../Model/BinDetailsModel/ScannLogModel.dart';

class ScannLockedAPiApi {
  static apiJsonMethod(ScanDataPost scandata) {
    log('Api Json message::${[
      {
        "auditid": scandata.auditid,
        "whscode": scandata.whscode,
        "bincode": scandata.bincode,
        "itemcode": scandata.itemCode,
        "serialbatch": scandata.serialbatch,
        "quantity": scandata.quantity,
        "stockstatus": scandata.stockstatus,
        "notes": scandata.notes,
        "devicecode": scandata.devicecode,
        "scandatetime": scandata.scandatetime,
        "ismanual": 0,
        "templateid": scandata.templateid,
        "scanguid": scandata.scanguid,
        "checklist": scandata.checklist!.map((e) => e.tojson2()).toList(),
      }
    ]}');
  }

  static Future<AuditScannLogModel> getData(ScanDataPost scandata) async {
    int resCode = 500;
//     log('message jsonsss:::' +
//         jsonEncode(

// [{}

//                   "auditid": scandata.auditid,
//                   "whscode": scandata.whscode,
//                   "bincode": scandata.bincode,
//                   "itemcode": scandata.itemCode,
//                   "serialbatch": scandata.serialbatch,
//                   "quantity": scandata.quantity,
//                   "stockstatus": scandata.stockstatus,
//                   "notes": scandata.notes,
//                   "devicecode": scandata.devicecode,
//                   "scandatetime": scandata.scandatetime,
//                   "ismanual": 0,
//                   "templateid": scandata.templateid,
//                   "scanguid": scandata.scanguid,
//                   "checklist": [],
//             ]
//               }
//             ]
//             );
    try {
      log('ConstantValues.token::${ConstantValues.token}');
      log(Url.queryApi + 'WareSmart/v1/PostAuditScanLog');
      final response = await http.post(
          Uri.parse(Url.queryApi + 'WareSmart/v1/PostAuditScanLog'),
          headers: {
            "accept": "/",
            "Authorization": 'bearer ' + ConstantValues.token,
            "content-type": "application/json",
          },
          body: jsonEncode(
              // scandata.map((e) => e.tojson()).toList(),
              [
                {
                  "auditid": scandata.auditid,
                  "whscode": scandata.whscode,
                  "bincode": scandata.bincode,
                  "itemcode": scandata.itemCode,
                  "serialbatch": scandata.serialbatch,
                  "quantity": scandata.quantity,
                  "stockstatus": scandata.stockstatus,
                  "notes": scandata.notes,
                  "devicecode": scandata.devicecode,
                  "scandatetime": scandata.scandatetime,
                  "ismanual": 0,
                  "templateid": scandata.templateid,
                  "scanguid": scandata.scanguid,
                  "checklist":
                      scandata.checklist!.map((e) => e.tojson2()).toList(),
                }
              ]));

      log("scan sts:::" "${response.statusCode.toString()}");
      log("scan Res:::" "${response.body.toString()}");

      resCode = response.statusCode;
      if (response.statusCode == 200) {
        return AuditScannLogModel.fromJson(
            json.decode(response.body) as Map<String, Object?>,
            response.statusCode);
      } else if (response.statusCode >= 400 && response.statusCode <= 410) {
        print("Error: error");
        return AuditScannLogModel.issue(response.statusCode,
            json.decode(response.body), response.statusCode);
      } else {
        log("APIERRor::" + json.decode(response.body).toString());
        return AuditScannLogModel.issue(response.statusCode,
            json.decode(response.body), response.statusCode);
      }
    } catch (e) {
      log("scan Catch:" + e.toString());
      throw Exception(e.toString());
      // return AuditScannLogModel.error(resCode, "$e");
    }
  }
}

// body: jsonEncode({
//             "deviceCode": "${postLoginData.deviceCode}",
//             "userName":"${postLoginData.username}",
//             "password": postLoginData.password.toString().isEmpty || postLoginData.password == null?"null":"${postLoginData.password}",
//             "licenseKey":postLoginData.licenseKey.toString().isEmpty  || postLoginData.licenseKey == null?"null": "${postLoginData.licenseKey}",
//            "fcmToken":"${postLoginData.fcmToken}"
//           }));
