import 'dart:developer';

import 'package:sqflite/sqlite_api.dart';
import 'package:verifytapp/DBModel/ItemTable/LineDBTable.dart';
import 'package:verifytapp/DBModel/ScanDataPostDB/ScanDataPushedDB.dart';
import 'package:verifytapp/DBModel/WarehouseDB/WarehouseTDB.dart';
import 'package:verifytapp/Model/ScanPostModel/ScanPostDataaModel.dart';
import 'package:verifytapp/Model/WareHouseModel/WarehouseDataModel.dart';

import '../DBModel/CheckListDB/CheckListTDB.dart';
import '../DBModel/ScanDataPostDB/ErrorCheckListTDB.dart';
import '../DBModel/ScanDataPostDB/PushedChecklistDB.dart';
import '../DBModel/ScanDataPostDB/ScannedErrorTable.dart';
import '../Model/AuditModel/AuditActionModel.dart';
import '../Model/AuditModel/AuditByDeviceModel.dart';
import '../DBModel/DispositionListDB/DispositionListTDB.dart';
import '../DBModel/GetAuditByDevice/GetAuditByDeviceDBModel.dart';
import '../DBModel/ItemTable/HeaderDataTable.dart';
import '../DBModel/ScanDataPostDB/ScandatapostTDB.dart';
import '../DBModel/ScanDataPostDB/checklistDBB.dart';
import '../Model/DispositionListModel/DispositionModel.dart';
import '../Model/ErrorModel/ErrorModeldaata.dart';

class DBOperation {
  static Future insertAuditByDervice(
      Database db, List<GetAuditDataModel> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(auditDataModelTableDB, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $auditDataModelTableDB
     ''');
    log("insertAuditBy result:: ${result.length}");
  }

  static Future<List<Map<String, Object?>>> getAuditByDervice(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $auditDataModelTableDB
''');
    return result;
  }

  // static updateActionTable(int id, String status, Database db) async {
  //   final List<Map<String, Object?>> result = await db.rawQuery('''
  //     UPDATE $auditDataModelTableDB
  //   SET Status = "$status" WHERE Id = $id;
  //   ''');
  //   return result;
  // }
  static Future insertAuditHeaderData(
      Database db, List<HeaderData> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(headerMasterTableDB, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $headerMasterTableDB
     ''');
    log("HeadData insert result:: ${result.length}");
  }

  static Future insertWhsListData(
      Database db, List<WareHouseListData> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(warehouseDb, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $warehouseDb
     ''');
    log("insertWhsListData result:: ${result.length}");
  }

  static Future getWhsDataList(
    Database db,
  ) async {
    List<Map<String, Object?>> result = await db.rawQuery('''
    select DISTINCT WhsCode, WhsName from $warehouseDb
     ''');
    // log("warehouseDb result:: ${result}");
    return result;
  }

  static Future insertscanpostData(
      Database db, List<ScanDataPost> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(scanpostTabled, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $scanpostTabled
     ''');
    log("scanpost111 result:: ${result}");
  }

  static Future insertPushedscanpostData(
      Database db, List<ScanDataPost> values) async {
    var data = values.map((e) => e.toMapSuccess()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(pushedScanTabled, es);
    });

    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $pushedScanTabled
     ''');
    log("pushedScanTabled result111:: ${result}");
  }

  static Future<List<Map<String, Object?>>> getpushedscandataData(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $pushedScanTabled
''');
    // log("pushedScanTabled Result222::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getpushedscandataDatabyid(
      Database db, int auditid) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $pushedScanTabled where Auditid=$auditid
''');
    log("pushedScanTabled Result333::${result.toString()}");
    return result;
  }

  static Future insertErrorscanpostData(
      Database db, List<ErrorScanDataPost> values) async {
    var data = values.map((e) => e.toMapErrors()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(errorScanTabled, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $errorScanTabled
     ''');
    log("scanpost111 result:: ${result}");
  }

  static Future<List<Map<String, Object?>>> geterrorscandataDatabyid(
      Database db, int auditid) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $errorScanTabled where Auditid=$auditid
''');
    log("pushedScanTabled Result444::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getErrorscandataData(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $errorScanTabled
''');
    log("errorScanTabled Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getAllErrorscandataData(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $errorScanTabled 
''');
    log("errorScanTabled Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> checkPushedAlreadyScandata(
      Database db, String serialbatch, String itemCode) async {
    log('''
SELECT * from $pushedScanTabled where Serialbatch="$serialbatch" and ItemCode="$itemCode"
''');
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $pushedScanTabled where Serialbatch="$serialbatch" and ItemCode="$itemCode"
''');
    log("checkScandata Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> checkErrorAlreadyScandata(
      Database db, String serialbatch, String itemCode) async {
    log('''
SELECT * from $errorScanTabled where Serialbatch="$serialbatch" and ItemCode="$itemCode"
''');
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $errorScanTabled where Serialbatch="$serialbatch" and ItemCode="$itemCode"
''');
    log("checkScandata Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> DeletepushedScandata(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
Delete from $pushedScanTabled
''');
    log("Pushedscanpost222 Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> DeleteScandata(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
Delete from $scanpostTabled
''');
    log("scanpost3333Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getscandataData(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanpostTabled 
''');
    // log("scanpost1111 Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getscandataDataBin(
      Database db, String binCode) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanpostTabled  where Bincode='$binCode'
''');
    // log("scanpost1111 Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getAllscandataDataLength(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanpostTabled
''');
    // log("scanpost555 Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getscandataDatabyId(
      Database db, int auditid) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanpostTabled where Auditid=$auditid
''');
    log("scanpostbyId Result::${result.toString()}");
    return result;
  }

// where Auditid=$auditid
  static Future<List<Map<String, Object?>>> checkScandata(
      Database db, String serialbatch, String itemCode) async {
    log('''
SELECT * from $scanpostTabled where Serialbatch="$serialbatch" and ItemCode="$itemCode"
''');
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanpostTabled where Serialbatch="$serialbatch" and ItemCode="$itemCode"
''');
    log("checkScandata Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> checkSsguIdScandata(
      Database db, String scanguidd) async {
    log('''
SELECT * from $scanpostTabled where scanguid="$scanguidd" 
''');
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanpostTabled where scanguid="$scanguidd"
''');
    log("checkScandata Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getchecklistAllData(
    Database db,
  ) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanchecklisttdb
''');
    log("checklisttdb11 Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getchecklistData(
      Database db, String scanguid) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $scanchecklisttdb where scanguid = '$scanguid'
''');
    log("scanchecklisttdb22 Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getSearchAllTables(
    Database db,
  ) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
select Bincode , Serialbatch , ItemCode,Quantity, Notes,Stockstatus,Scandatetime,scanguid , ApiErrorMsg ,'Error' Status ,Whscode from ErrorScannedDataTable 
UNION All 
select Bincode , Serialbatch , ItemCode,Quantity,Notes,Stockstatus,Scandatetime,scanguid ,'','Scanned' ,Whscode from ScanPostDataTTable 
UNION All 
select Bincode , Serialbatch , ItemCode,Quantity,Notes,Stockstatus,Scandatetime ,scanguid ,'','Synced' ,Whscode from PushedScanPostDataTable
''');
    log("search Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getDeleteScanlistData(
    Database db,
    String scanguid,
  ) async {
//     delete from SalesPay where docentry = $docEntry

    final List<Map<String, Object?>> result = await db.rawQuery('''
 delete from $scanpostTabled where scanguid = '$scanguid'
''');
    log("scanchecklisttDelete Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getDeleteerrorScanlistData(
      Database db, String scanguid) async {
//     delete from SalesPay where docentry = $docEntry

    final List<Map<String, Object?>> result = await db.rawQuery('''
 delete from $errorScanTabled where scanguid = '$scanguid'
''');
    log("scanchecklisttdb4444 Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getDeleteerrorScanlist(
    Database db,
  ) async {
//     delete from SalesPay where docentry = $docEntry

    final List<Map<String, Object?>> result = await db.rawQuery('''
 delete from $errorScanTabled 
''');
    log("22222222222 Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getDeletechecklistData(
      Database db, int auditId) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
delete from from $scanchecklisttdb where Auditid = $auditId
''');
    log("scanchecklisttdb44 Result::${result.length.toString()}");
    return result;
  }

  static Future insertchecklistData(
      Database db, List<DispListData> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(scanchecklisttdb, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $scanchecklisttdb
     ''');
    log("insertchecklist result:: ${result}");
  }

  static Future insertPushedchecklistData(
      Database db, List<DispListData> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(pushedCklisttdb, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $pushedCklisttdb
     ''');
    log("DispListData result:: ${result.length}");
  }

  static Future inserterrorchecklistData(
      Database db, List<DispListData> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(errorCklisttdb, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $errorCklisttdb
     ''');
    log("DispListData result:: ${result.length}");
  }

  static Future insertDispData(
      Database db, List<GetDisPositonList> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert(disPositonListDBT, es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $disPositonListDBT
     ''');
    log("Insert DispListData:: ${result.length}");
  }

  static Future<List<Map<String, Object?>>> getDispDataList(Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT DISTINCT DisPositionVal FROM $disPositonListDBT where DisPositionVal IS NOT NULL
''');
    // log("disPositonListDBT Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getAllDispDataList(
    Database db,
    int dispCode,
  ) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * FROM $disPositonListDBT where DispID=$dispCode
''');
    log("Selected disPositonListDBT Result::${result.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getAuditHeaderData(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $headerMasterTableDB
''');
    log("HeadDataDBTable Result::${result.length.toString()}");
    return result;
  }

  static Future insertAuditLineData(Database db, List<LineData> values) async {
    var data = values.map((e) => e.toMap()).toList();
    var batch = db.batch();
    data.forEach((es) async {
      batch.insert('LineDataTable', es);
    });
    await batch.commit();
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $lineDataDBTable
     ''');
    log("LineData result:: ${result.length}");
  }

  static Future<List<Map<String, Object?>>> getAuditLineData(
      Database db) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $lineDataDBTable
''');
    log("lineDataDBTable Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> checkBinInAuditLineData(
      Database db, String columnVal, String binNum) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT * from $lineDataDBTable where $columnVal='$binNum'
''');
    log("checkBinInAuditLineData Result::${result.length.toString()}");
    return result;
  }

  static Future<List<Map<String, Object?>>> getBinInAuditLineData(
    Database db,
  ) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT BinCode, ItemCode, SerailBatch from $lineDataDBTable LIMIT 10
''');
    log("BinCode Result::${result.toString()}");
    return result;
  }

  // static Future insertCheckListData(
  //     Database db, List<CheckListLineData> values) async {
  //   var data = values.map((e) => e.toMap()).toList();
  //   var batch = db.batch();
  //   data.forEach((es) async {
  //     batch.insert(checkListDataDB, es);
  //   });
  //   await batch.commit();
  //   List<Map<String, Object?>> result = await db.rawQuery('''
  //   select * from $checkListDataDB
  //    ''');
  //   log("checkListDataDB result:: ${result.length}");
  // }

  static Future<List<Map<String, Object?>>> getCheckListData(
    Database db,
  ) async {
    final List<Map<String, Object?>> result = await db.rawQuery('''
SELECT *  from $checkListDataDB 
''');
    log("CheckListData Result::${result.toString()}");
    return result;
  }

  static Future<void> truncateAuditByDevice(Database db) async {
    await db.rawQuery('delete from $auditDataModelTableDB');
  }

  static Future<void> truncateWarehouseDb(Database db) async {
    await db.rawQuery('delete from $warehouseDb');
  }

//warehouseDb
  static Future<void> truncateAuditHeader(Database db) async {
    await db.rawQuery('delete from $headerMasterTableDB');
  }

  static Future<void> truncateAuditLine(Database db) async {
    await db.rawQuery('delete from $lineDataDBTable');
  }

  static Future<void> truncatedispval(Database db) async {
    await db.rawQuery('delete from $disPositonListDBT');
  }

  static Future<void> truncheckListDataDB(Database db) async {
    await db.rawQuery('delete from $checkListDataDB');
  }

  static Future<void> truncateScanpostDataT(Database db) async {
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $scanpostTabled
     ''');
    log("scanpost333 result:: ${result.length}");
    await db.rawQuery('delete from $scanpostTabled');
    List<Map<String, Object?>> result2 = await db.rawQuery('''
    select * from $scanpostTabled
     ''');
    log("scanpost444 result:: ${result2.length}");
  }

  static Future<void> truncateCheckListT(Database db) async {
    List<Map<String, Object?>> result = await db.rawQuery('''
    select * from $scanchecklisttdb
     ''');
    log("checklis11 result:: ${result.length}");
    await db.rawQuery('delete from $scanchecklisttdb');
    List<Map<String, Object?>> result2 = await db.rawQuery('''
    select * from $scanchecklisttdb
     ''');
    log("checklis22 result:: ${result2.length}");
  }
}
