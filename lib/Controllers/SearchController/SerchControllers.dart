import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import '../../DBHelper/DBHelpers.dart';
import '../../DBHelper/DBOperations.dart';
import '../../Model/SearchModel/SearchModelData.dart';

class SearchCtrl extends ChangeNotifier {
  init() {
    clearAllData();
  }

  TextEditingController SearchController = TextEditingController();
  List<SearchScanDataPost> searchListValues = [];
  List<SearchScanDataPost> fileterSearchValues = [];

  clearAllData() {
    searchListValues = [];
    SearchController.text = '';
    fileterSearchValues = [];
    notifyListeners();
  }

  getSerachValues(String docEntry) async {
    searchListValues = [];
    fileterSearchValues = [];
    Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> result2 =
        await DBOperation.getSearchAllTables(db, docEntry);

    if (result2.isNotEmpty) {
      for (var i = 0; i < result2.length; i++) {
        searchListValues.add(SearchScanDataPost(
            bincode: result2[i]['Bincode'].toString(),
            scanguid: result2[i]['scanguid'].toString(),
            errormsg: result2[i]['ApiErrorMsg'].toString(),
            itemCode: result2[i]['ItemCode'].toString(),
            status: result2[i]['Status'].toString(),
            notes: result2[i]['Notes'].toString(),
            quantity: double.parse(result2[i]['Quantity'].toString()),
            scandatetime: result2[i]['Scandatetime'].toString(),
            serialbatch: result2[i]['Serialbatch'].toString(),
            stockstatus: result2[i]['Stockstatus'].toString(),
            checklist: [],
            whscode: result2[i]['Whscode'].toString()));
      }
      fileterSearchValues = searchListValues;

      notifyListeners();
    }
    notifyListeners();
  }

  filterSearchBoxList(String v) {
    if (v.isNotEmpty) {
      log('searchListValues lenght::${searchListValues.length}');
      fileterSearchValues = searchListValues
          .where((e) =>
              e.bincode!.toLowerCase().contains(v.toLowerCase()) ||
              e.serialbatch
                  .toString()
                  .toLowerCase()
                  .contains(v.toLowerCase()) ||
              e.itemCode.toString().toLowerCase().contains(v.toLowerCase()) ||
              e.notes!.toString().toLowerCase().contains(v.toLowerCase()))
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      fileterSearchValues = searchListValues;
      notifyListeners();
    }
    log("fileterSearchValues::${fileterSearchValues.length}");
  }
}
