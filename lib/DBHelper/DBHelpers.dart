import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:verifytapp/DBModel/CheckListDB/CheckListTDB.dart';
import 'package:verifytapp/DBModel/DispositionListDB/DispositionListTDB.dart';
import 'package:verifytapp/DBModel/ItemTable/LineDBTable.dart';
import 'package:verifytapp/DBModel/ScanDataPostDB/PushedChecklistDB.dart';
import 'package:verifytapp/DBModel/ScanDataPostDB/ScanDataPushedDB.dart';
import 'package:verifytapp/DBModel/WarehouseDB/WarehouseTDB.dart';
import '../DBModel/GetAuditByDevice/GetAuditByDeviceDBModel.dart';
import '../DBModel/ItemTable/HeaderDataTable.dart';
import '../DBModel/ScanDataPostDB/ErrorCheckListTDB.dart';
import '../DBModel/ScanDataPostDB/ScandatapostTDB.dart';
import '../DBModel/ScanDataPostDB/ScannedErrorTable.dart';
import '../DBModel/ScanDataPostDB/checklistDBB.dart';

class DBHelper {
  static Database? _db;

  DBHelper._() {}
  static Future<Database?> getInstance() async {
    String path = await getDatabasesPath();
    if (_db == null) {
      _db = await openDatabase(join(path, 'Verifyt.db'),
          version: 1, onCreate: createTable);
    }
    return _db;
  }

  static void createTable(Database database, int version) async {
    await database.execute('''
           create table $auditDataModelTableDB(
             Id integer primary key autoincrement,
             ${GetAuditDataModelDB.docEntry} integer ,
             ${GetAuditDataModelDB.docNum} varchar ,
             ${GetAuditDataModelDB.user} varchar ,
             ${GetAuditDataModelDB.docDate} varchar ,
             ${GetAuditDataModelDB.auditFrom} varchar ,
             ${GetAuditDataModelDB.auditTo} varchar ,
             ${GetAuditDataModelDB.scheduleName} varchar ,
             ${GetAuditDataModelDB.status} varchar ,
             ${GetAuditDataModelDB.startDate} varchar ,
             ${GetAuditDataModelDB.endDate} varchar ,
             ${GetAuditDataModelDB.unitsScanned} decimal ,
             ${GetAuditDataModelDB.totalItems} decimal ,
             ${GetAuditDataModelDB.traceid} varchar ,
             ${GetAuditDataModelDB.blockTrans} varchar ,
             ${GetAuditDataModelDB.createdBy} varchar ,
             ${GetAuditDataModelDB.createdDatetime} varchar ,
             ${GetAuditDataModelDB.whsCode} varchar ,
             ${GetAuditDataModelDB.repeat} varchar ,
             ${GetAuditDataModelDB.repeatDay} varchar ,
             ${GetAuditDataModelDB.repeatFrequency} varchar ,
             ${GetAuditDataModelDB.remarks} varchar ,
             ${GetAuditDataModelDB.percent} decimal ,
             ${GetAuditDataModelDB.updatedBy} varchar,
             ${GetAuditDataModelDB.updatedDatetime} varchar 
             )
        ''');
    await database.execute('''
           create table $headerMasterTableDB (
             HId integer primary key autoincrement,
             ${HeaderTableDB.auditScheduleID} integer ,
              ${HeaderTableDB.id} integer ,
             ${HeaderTableDB.brand} varchar ,
             ${HeaderTableDB.brandCode} varchar ,
            ${HeaderTableDB.category} varchar ,
             ${HeaderTableDB.clasification} varchar ,
             ${HeaderTableDB.color} varchar ,
             ${HeaderTableDB.createdDateTime} varchar ,
             ${HeaderTableDB.createdBy} varchar ,
            ${HeaderTableDB.expiryDays} varchar ,
             ${HeaderTableDB.hasExpiryDate} varchar ,
             ${HeaderTableDB.height} varchar ,
             ${HeaderTableDB.imageURL} varchar ,
             ${HeaderTableDB.inwardPackQty} varchar ,
            ${HeaderTableDB.inwardUoM} varchar ,
             ${HeaderTableDB.isFragile} varchar ,
             ${HeaderTableDB.isPerishable} varchar ,
              ${HeaderTableDB.itemCode} varchar ,
             ${HeaderTableDB.itemDescription} varchar ,
             ${HeaderTableDB.itemGroup} varchar ,
            ${HeaderTableDB.itemName} varchar ,
             ${HeaderTableDB.itemType} varchar ,
             ${HeaderTableDB.sKUCode} varchar ,
              ${HeaderTableDB.length} varchar ,
             ${HeaderTableDB.manageBy} varchar ,
             ${HeaderTableDB.modelNo} varchar ,
            ${HeaderTableDB.movingType} varchar ,
             ${HeaderTableDB.uoM} varchar ,
             ${HeaderTableDB.outwardPackQty} varchar ,
              ${HeaderTableDB.outwardUoM} varchar ,
             ${HeaderTableDB.partCode} varchar ,
             ${HeaderTableDB.sizeCapacity} varchar ,
            ${HeaderTableDB.specification} varchar ,
             ${HeaderTableDB.status} varchar ,
             ${HeaderTableDB.subCategory} varchar ,
              ${HeaderTableDB.taxRate} varchar ,
             ${HeaderTableDB.textNote} varchar ,
             ${HeaderTableDB.traceid} varchar ,
            ${HeaderTableDB.updatedBy} varchar ,
             ${HeaderTableDB.updatedDateTime} varchar ,
             ${HeaderTableDB.volume} varchar ,
            ${HeaderTableDB.weight} varchar ,
             ${HeaderTableDB.width} varchar 
           
             )
        ''');
    await database.execute('''
           create table LineDataTable (
             Id integer primary key autoincrement,
             ${ActionLineDBTable.autoId} integer ,
             ${ActionLineDBTable.binCode} varchar ,
             ${ActionLineDBTable.createdBy} varchar ,
             ${ActionLineDBTable.createdDatetime} varchar ,
             ${ActionLineDBTable.itemCode} varchar ,
             ${ActionLineDBTable.quantity} decimal ,
             ${ActionLineDBTable.scheduleId} varchar ,
             ${ActionLineDBTable.serailBatch} varchar ,
             ${ActionLineDBTable.traceid} varchar ,
             ${ActionLineDBTable.uoM} varchar ,
             ${ActionLineDBTable.updatedBy} varchar ,
             ${ActionLineDBTable.whsCode} varchar ,
            ${ActionLineDBTable.updatedDatetime} varchar 
             )
        ''');

    await database.execute('''
           create table $scanpostTabled (
             SId integer primary key autoincrement,
             ${ScanPostTableDBT.auditid} integer ,
             ${ScanPostTableDBT.bincode} varchar ,
             ${ScanPostTableDBT.itemCode} varchar ,
             ${ScanPostTableDBT.devicecode} varchar ,
             ${ScanPostTableDBT.quantity} decimal ,
             ${ScanPostTableDBT.notes} varchar ,
             ${ScanPostTableDBT.whscode} varchar ,
             ${ScanPostTableDBT.ismanual} varchar ,
             ${ScanPostTableDBT.serialbatch} varchar ,
             ${ScanPostTableDBT.stockstatus} varchar ,
             ${ScanPostTableDBT.scandatetime} varchar ,
             ${ScanPostTableDBT.templateid} varchar,
               ${ScanPostTableDBT.scanguid} varchar
             
             )
        ''');
    await database.execute('''
           create table $scanchecklisttdb (
             CId integer primary key autoincrement,
             ${CheckListDBT.auditid} integer ,
             ${CheckListDBT.attachurl} varchar ,
             ${CheckListDBT.checklistcode} varchar ,
             ${CheckListDBT.checklistvalue} varchar,
             ${CheckListDBT.scanguid} varchar            
             )
        ''');
    await database.execute('''
           create table $pushedScanTabled (
             PSId integer primary key autoincrement,
             ${PushedScanTableDBT.auditid} integer ,
             ${PushedScanTableDBT.bincode} varchar ,
             ${PushedScanTableDBT.itemCode} varchar ,
             ${PushedScanTableDBT.devicecode} varchar ,
             ${PushedScanTableDBT.quantity} decimal ,
             ${PushedScanTableDBT.notes} varchar ,
             ${PushedScanTableDBT.whscode} varchar ,
             ${PushedScanTableDBT.ismanual} varchar ,
             ${PushedScanTableDBT.serialbatch} varchar ,
             ${PushedScanTableDBT.stockstatus} varchar ,
             ${PushedScanTableDBT.scandatetime} varchar ,
             ${PushedScanTableDBT.templateid} varchar,
              ${PushedScanTableDBT.scanguid} varchar
             )
        ''');
    await database.execute('''
           create table $errorScanTabled (
             PSId integer primary key autoincrement,
             ${ErrorScanTableDBT.auditid} integer ,
             ${ErrorScanTableDBT.bincode} varchar ,
             ${ErrorScanTableDBT.itemCode} varchar ,
             ${ErrorScanTableDBT.devicecode} varchar ,
             ${ErrorScanTableDBT.quantity} decimal ,
             ${ErrorScanTableDBT.notes} varchar ,
             ${ErrorScanTableDBT.whscode} varchar ,
             ${ErrorScanTableDBT.ismanual} varchar ,
             ${ErrorScanTableDBT.serialbatch} varchar ,
             ${ErrorScanTableDBT.stockstatus} varchar ,
             ${ErrorScanTableDBT.scandatetime} varchar ,
             ${ErrorScanTableDBT.templateid} varchar,
             ${ErrorScanTableDBT.scanguid} varchar,
             ${ErrorScanTableDBT.apiErrorMsg} varchar

             )
        ''');
    await database.execute('''
           create table $pushedCklisttdb (
             
             PCId integer primary key autoincrement,
             ${PushedCheckListDBT.auditid} integer ,
             ${PushedCheckListDBT.attachurl} varchar ,
             ${PushedCheckListDBT.checklistcode} varchar ,
             ${PushedCheckListDBT.checklistvalue} varchar            
             )
        ''');
    await database.execute('''
           create table $errorCklisttdb (
             
             PCId integer primary key autoincrement,
             ${ErrorCheckListDBT.auditid} integer ,
             ${ErrorCheckListDBT.attachurl} varchar ,
             ${ErrorCheckListDBT.checklistcode} varchar ,
             ${ErrorCheckListDBT.checklistvalue} varchar            
             )
        ''');
    //DisPositonListTable
    await database.execute('''
           create table $disPositonListDBT (
             DId integer primary key autoincrement,
             ${DisPositonListTable.dispID} integer ,
             ${DisPositonListTable.dispositionVal} varchar
             )
        ''');
    // {\"DocEntry\":3,\"TemplateName\":\"Furniture\",\"DocEntry1\":3,\"ChecklistCode\":\"C7\",
//\"ChecklistName\":\"Any Scratches\",\"ListValue\":\"Yes,No\",\"AcceptAttach\":false,\"AcceptMultiValue\":false,\"isMandaory\":true,\"CreatedBy\":1,
//\"CreatedDatetime\":\"2024-07-24T00:00:00\",\"UpdatedBy\":null,\"UpdatedDatetime\":null,\"traceid\":\"ff034a19-c155-4f56-8568-902514081e79\"},

    await database.execute('''
           create table $checkListDataDB (
          
             ${CheckListDataTable.docEntry} integer ,
             ${CheckListDataTable.docEntry1} integer ,
             ${CheckListDataTable.templateName} varchar ,
             ${CheckListDataTable.checklistName} varchar ,
             ${CheckListDataTable.checklistCode} varchar ,
             ${CheckListDataTable.listValue} varchar ,
             ${CheckListDataTable.acceptAttach} varchar ,
             ${CheckListDataTable.acceptMultiValue} varchar ,
             ${CheckListDataTable.isMandaory} varchar ,
             ${CheckListDataTable.createdBy} varchar,
             ${CheckListDataTable.createdDatetime} varchar,
            ${CheckListDataTable.updatedBy} varchar ,
             ${CheckListDataTable.updatedDatetime} varchar,
             ${CheckListDataTable.traceid} varchar
             )
        ''');
    //WarehouseDBTable
    await database.execute('''
           create table $warehouseDb (
          
             ${WarehouseDBTable.whsName} varchar ,
             ${WarehouseDBTable.whsCode} varchar ,
             ${WarehouseDBTable.address1} varchar ,
             ${WarehouseDBTable.address2} varchar ,
             ${WarehouseDBTable.address3} varchar ,
             ${WarehouseDBTable.city} varchar ,
             ${WarehouseDBTable.country} varchar ,
             ${WarehouseDBTable.state} varchar ,
             ${WarehouseDBTable.status} varchar ,
             ${WarehouseDBTable.gstNo} varchar ,
             ${WarehouseDBTable.picode} varchar ,
             ${WarehouseDBTable.latitude} varchar ,
             ${WarehouseDBTable.longitude} varchar ,
             ${WarehouseDBTable.primaryContact} varchar ,
             ${WarehouseDBTable.primaryEmail} varchar ,
             ${WarehouseDBTable.createdBy} varchar,
             ${WarehouseDBTable.createdOn} varchar,
             ${WarehouseDBTable.updatedBy} varchar ,
             ${WarehouseDBTable.updatedOn} varchar,
             ${WarehouseDBTable.traceid} varchar
             )
        ''');
  }
}
