// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_new, non_constant_identifier_names, unnecessary_string_interpolations, unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../Constant/ConstantSapValues.dart';
import '../../Constant/LocalUrl/GetLocalUrl.dart';
import '../../Model/AuditModel/AuditCancelModel.dart';

class GetAuditCancelApi {
  static Future<GetCancelModel> getData(int docEntry, String reason) async {
    int resCode = 500;

    try {
      // log('ConstantValues.token::${ConstantValues.token}');
      log(Url.queryApi + 'WareSmart/v1/Pos6AuditCancel/$docEntry/$reason');
      final response = await http.post(
        Uri.parse(Url.queryApi +
            'api/WareSmart/v1/PoseAuditCancel/$docEntry/$reason'),
        headers: {
          "accept": "/",
          "Authorization": 'bearer ' + ConstantValues.token,
        },
      );

      log("AuditCancel sts:::${response.statusCode.toString()}");
      log("AuditCancel Res:::${response.body.toString()}");

      resCode = response.statusCode;
      if (response.statusCode == 200) {
        return GetCancelModel.fromJson(
            json.decode(response.body) as Map<String, Object?>,
            response.statusCode);
      } else if (response.statusCode >= 400 && response.statusCode <= 410) {
        print("Error: error");
        return GetCancelModel.issue(response.statusCode,
            json.decode(response.body), response.statusCode);
      } else {
        log("APIERRor::" + json.decode(response.body).toString());
        return GetCancelModel.issue(response.statusCode,
            json.decode(response.body), response.statusCode);
      }
    } catch (e) {
      log("Catch:" + e.toString());
      return GetCancelModel.error(resCode, "$e");
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
