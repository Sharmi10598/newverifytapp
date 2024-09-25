import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import '../../Constant/ConstantSapValues.dart';
import '../../Constant/LocalUrl/GetLocalUrl.dart';
import '../../Model/CheckListModel/CheckLstModel.dart';
import '../../Model/DispositionListModel/DispositionModel.dart';
import '../../Model/ErrorModel/ErrorModeldaata.dart';
import '../../Model/LoadItemsItemCodeModel/LoadItemCodeModel.dart';
import '../../Model/ScanPostModel/ScanPostDataaModel.dart';
import '../../Pages/AuditPages/Widgets/Imagepickerscree.dart';
import '../../Pages/ItemDetailsPages/ScanDetialsBottomSheet.dart';
import '../../Services/AttachmentApi/AttachmentFileLinkApi.dart';
import '../../Services/GetAuditApi/loadCompleteApi.dart';
import '../../Services/LoadMasterApi/LoadItemCodeApii.dart';
import '../../driftDB/driftTablecreation.dart';
import '../../driftDB/driftoperation.dart';
import 'Dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:verifytapp/Constant/Configuration.dart';
import 'package:verifytapp/DBHelper/DBOperations.dart';
import '../../Constant/Helper.dart';
import '../../Constant/Screen.dart';
import '../../DBHelper/DBHelpers.dart';
import '../../Model/AuditModel/AuditActionModel.dart';
import '../../Model/AuditModel/AuditModels.dart';
import '../../Model/AuditModel/AuditByDeviceModel.dart';
import '../../Model/BinDetailsModel/DefaultBinModel.dart';
import '../../Model/BinDetailsModel/ScannLogModel.dart';
import '../../Model/UserDetailsModel/UserDetailsModels.dart';
import '../../Services/BinLockApi/BinLockedApi.dart';
import '../../Services/BinLockApi/ScannlogAPI.dart';
import '../../Services/GetAuditApi/AuditActionApi.dart';
import '../../Services/GetAuditApi/AuditCancelApi.dart';
import '../../Services/GetAuditApi/AuditRescheduleApi.dart';
import '../../Services/GetAuditApi/GetAuditByDeviceAPI.dart';
import '../../Services/GetBinDetailsApi/GetDefaultBinDetApi.dart';
import '../../Services/UserDetails/userDetailsApi.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:uuid/uuid.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;

class AuditCtrlProvider extends ChangeNotifier {
  List<AuditModelList> auditList = [];
  Config config = Config();

  init(BuildContext context, ThemeData theme) async {
    audioPlayer = AudioPlayer();
    Database db = (await DBHelper.getInstance())!;
    clearAllData();
    setURL();
    await getAuditBydeviceData();
    scantotaldeviceqty();
    getCheckListForm();

    await DBOperation.getchecklistAllData(db);
  }

  // DBOperation.DeletepushedScandata(db);
  // DBOperation.getDeleteerrorScanlist(db);
  // DBOperation.DeleteScandata(db);
  // DBOperation.truncateCheckListT(db);

  int? groupValueSelected = 0;
  int? get getgroupValueSelected => groupValueSelected;
  bool freezeqty = false;
  bool freezeItemCode = false;
  bool nextdisable = false;
  bool resetaudit = false;
  List<LineData> lineresult = [];
  List<HeaderData> headerresult = [];
  List<CheckListData> getCkeckDataList = [];
  String isSelectedCusTagcode = '';
  List<GetDisPositonList> dispvalList = [];
  List<GetDisPositonList> dispAllvalList = [];
  String isSelectedCusTag = '';
  String isSelectedChecklistTag = '';

  List<File> files = [];
  FilePickerResult? result;
  List<FilesData> filedata = [];
  String urlImage = '';
  bool isLoading = true;

  List<GetAuditDataModel> getAuditList = [];
  List<GetAuditDataModel> getAuditList2 = [];
  List<GetAuditDataModel> openAuditList = [];
  List<GetAuditDataModel> completedAuditList = [];
  List<GetAuditDataModel> upcomingtAuditList = [];
  bool isClickedStart = false;
  FetchAuditDetais fetchAuditForDetails = FetchAuditDetais();

  List<GlobalKey<FormState>> formkey =
      List.generate(20, (i) => GlobalKey<FormState>());

  List<TextEditingController> mycontroller =
      List.generate(50, (i) => TextEditingController());

  int totalScan = 0;
  int totalScanPost = 0;
  int totalSuccess = 0;
  int totalError = 0;
  List<ErrorScanDataPost> viewerrorDetails = [];
  List<ScanDataPost> viewSuccessDetails = [];
  List<ScanDataPost> viewScanMainDetails = [];
  List<ScanDataPost> binDetails = [];

  Uuid uuid = const Uuid();
  List<ScanDataPost> scandata = [];
  List<DispListData> checklistdata = [];
  String skuCosde = '';
  String itemCode = '';
  String scanTime = '';
  String itemName = '';
  int? dispCode;
  String serialBatch = '';
  String mangedBy = '';

  List<LoadItemCodeLists> itemCodeList = [];

  List<HeaderData> auditActionHeaderList = [];
  List<LineData> auditActionLineList = [];
  List<BinMasterData> auditActionBinMasterList = [];
  List<GetUserDataModel> usetDetailData = [];
  List<CheckListLineData> getckeckDataListForm = [];
  int stockRecord = 0;
  int binRecord = 0;
  int itemMasterRecord = 0;
  String? lastdowntimeStamp;
  String? lastDocTimeSStamp;
  List<AuditScannLogDataModel> auditScannData = [];
  List<GetBinData> getBinList = [];

  bool tableColumLoad = false;
  int incQty = 0;
  bool isManualtype = false;
  bool whileOffline = false;
  bool seriesfocus = true;
  static String? path = '';
  List<ScanDataPost> pushedexcelvaluers = [];
  List<ScanDataPost> pendingexcelvaluers = [];
  List<ErrorScanDataPost> errorexcelvaluers = [];
  List<LineData> listScanBatch = [];

  binTableDetails(String binVal) async {
    Database db = (await DBHelper.getInstance())!;
    binDetails = [];
    List<Map<String, Object?>> result2 =
        await DBOperation.getscandataDataBin(db, binVal);
    if (result2.isNotEmpty) {
      for (var i = 0; i < result2.length; i++) {
        binDetails.add(ScanDataPost(
            auditid: int.parse(result2[i]['Auditid'].toString()),
            bincode: result2[i]['Bincode'].toString(),
            scanguid: result2[i]['scanguid'].toString(),
            devicecode: result2[i]['Devicecode'].toString(),
            checklist: [],
            ismanual: int.parse(result2[i]['IsManual'].toString()),
            // errormsg: pushedScannedPostData[i]['ApiErrorMsg'].toString(),
            itemCode: result2[i]['ItemCode'].toString(),
            notes: result2[i]['Notes'].toString(),
            quantity: double.parse(result2[i]['Quantity'].toString()),
            scandatetime: result2[i]['Scandatetime'].toString(),
            serialbatch: result2[i]['Serialbatch'].toString(),
            stockstatus: result2[i]['Stockstatus'].toString(),
            templateid: result2[i]['Templateid'] != null
                ? int.parse(result2[i]['Templateid'].toString())
                : 0,
            whscode: result2[i]['Whscode'].toString()));
        notifyListeners();
      }
      notifyListeners();
    }
  }

  checkCtrlFocus() {
    if (mycontroller[2].text.isNotEmpty) {
      focus2.requestFocus();
      notifyListeners();
    } else {
      focus1.requestFocus();
      focus2.unfocus();
      notifyListeners();
    }
  }

  getTotalLengthItems(int docentry) async {
    final database = (await AppDatabase.initialize())!;

    List<LineData> linedataLength =
        await driftoperation.getallLineproductLength(database, docentry);
    List<HeaderData> headerlength =
        await driftoperation.getItemCodeInHeaderLength(database, docentry);
    List<BinMasterData> binLength =
        await driftoperation.getBinMasterdataLength(database, docentry);
    stockRecord = int.parse(linedataLength.length.toString());
    itemMasterRecord = int.parse(headerlength.length.toString());
    binRecord = int.parse(binLength.length.toString());
  }

  int? totalscandevicecount = 0;
  int? totalscandeviceQty = 0;

  scantotaldeviceqty() async {
    totalscandevicecount = 0;
    totalscandeviceQty = 0;
    int scanqtyy = 0;
    int successqtyy = 0;
    int errorrrtyy = 0;
    totalscandeviceQty = 0;

    Database db = (await DBHelper.getInstance())!;

    List<Map<String, Object?>> scannedPostData =
        await DBOperation.getAllscandataDataLength(
      db,
    );
    for (var i = 0; i < scannedPostData.length; i++) {
      scanqtyy =
          scanqtyy + int.parse(scannedPostData[i]['Quantity'].toString());
      notifyListeners();
    }
    List<Map<String, Object?>> pushedScannedPostData =
        await DBOperation.getpushedscandataData(
      db,
    );

    for (var i = 0; i < pushedScannedPostData.length; i++) {
      successqtyy = successqtyy +
          int.parse(pushedScannedPostData[i]['Quantity'].toString());
      notifyListeners();
    }
    List<Map<String, Object?>> errorScannedPostData =
        await DBOperation.getAllErrorscandataData(db);

    for (var i = 0; i < errorScannedPostData.length; i++) {
      errorrrtyy = errorrrtyy +
          int.parse(errorScannedPostData[i]['Quantity'].toString());
      notifyListeners();
    }
    totalscandeviceQty = 0;
    totalscandevicecount = int.parse(scannedPostData.length.toString()) +
        int.parse(pushedScannedPostData.length.toString()) +
        int.parse(errorScannedPostData.length.toString());
    totalscandeviceQty = scanqtyy + successqtyy + errorrrtyy;
    log('totalscandeviceQtytotalscandeviceQty::${totalscandeviceQty}');
    notifyListeners();
  }

  getScannedInformation(int docentry) async {
    totalScan = 0;
    totalScanPost = 0;
    totalSuccess = 0;
    totalError = 0;
    viewerrorDetails = [];
    viewScanMainDetails = [];
    viewSuccessDetails = [];
    stockRecord = 0;
    binRecord = 0;
    itemMasterRecord = 0;
    Database db = (await DBHelper.getInstance())!;

    List<Map<String, Object?>> scannedPostData =
        await DBOperation.getscandataDatabyId(db, docentry);
    List<Map<String, Object?>> pushedScannedPostData =
        await DBOperation.getpushedscandataDatabyid(db, docentry);
    List<Map<String, Object?>> errorScannedPostData =
        await DBOperation.geterrorscandataDatabyid(db, docentry);
    totalScan = int.parse(scannedPostData.length.toString()) +
        int.parse(pushedScannedPostData.length.toString()) +
        int.parse(errorScannedPostData.length.toString());
    totalSuccess = int.parse(pushedScannedPostData.length.toString());
    totalError = int.parse(errorScannedPostData.length.toString());
    log('scannedPostDatascannedPostData::${scannedPostData.length}');
    for (var i = 0; i < scannedPostData.length; i++) {
      viewScanMainDetails.add(ScanDataPost(
          auditid: int.parse(scannedPostData[i]['Auditid'].toString()),
          bincode: scannedPostData[i]['Bincode'].toString(),
          scanguid: scannedPostData[i]['scanguid'].toString(),
          devicecode: scannedPostData[i]['Devicecode'].toString(),
          checklist: [],
          ismanual: int.parse(scannedPostData[i]['IsManual'].toString()),
          // errormsg: scannedPostData[i]['ApiErrorMsg'].toString(),
          itemCode: scannedPostData[i]['ItemCode'].toString(),
          notes: scannedPostData[i]['Notes'].toString(),
          quantity: double.parse(scannedPostData[i]['Quantity'].toString()),
          scandatetime: scannedPostData[i]['Scandatetime'].toString(),
          serialbatch: scannedPostData[i]['Serialbatch'].toString(),
          stockstatus: scannedPostData[i]['Stockstatus'].toString(),
          templateid: scannedPostData[i]['Templateid'] != null
              ? int.parse(scannedPostData[i]['Templateid'].toString())
              : 0,
          whscode: scannedPostData[i]['Whscode'].toString()));
      notifyListeners();
    }
    log('viewScanMainDetailsviewScanMainDetails::${viewScanMainDetails.length}');

    for (var i = 0; i < pushedScannedPostData.length; i++) {
      viewSuccessDetails.add(ScanDataPost(
          auditid: int.parse(pushedScannedPostData[i]['Auditid'].toString()),
          bincode: pushedScannedPostData[i]['Bincode'].toString(),
          scanguid: pushedScannedPostData[i]['scanguid'].toString(),
          devicecode: pushedScannedPostData[i]['Devicecode'].toString(),
          checklist: [],
          ismanual: int.parse(pushedScannedPostData[i]['IsManual'].toString()),
          // errormsg: pushedScannedPostData[i]['ApiErrorMsg'].toString(),
          itemCode: pushedScannedPostData[i]['ItemCode'].toString(),
          notes: pushedScannedPostData[i]['Notes'].toString(),
          quantity:
              double.parse(pushedScannedPostData[i]['Quantity'].toString()),
          scandatetime: pushedScannedPostData[i]['Scandatetime'].toString(),
          serialbatch: pushedScannedPostData[i]['Serialbatch'].toString(),
          stockstatus: pushedScannedPostData[i]['Stockstatus'].toString(),
          templateid: pushedScannedPostData[i]['Templateid'] != null
              ? int.parse(pushedScannedPostData[i]['Templateid'].toString())
              : 0,
          whscode: pushedScannedPostData[i]['Whscode'].toString()));
      notifyListeners();
    }

    if (errorScannedPostData.isNotEmpty) {
      for (var i = 0; i < errorScannedPostData.length; i++) {
        viewerrorDetails.add(ErrorScanDataPost(
            auditid: int.parse(errorScannedPostData[i]['Auditid'].toString()),
            bincode: errorScannedPostData[i]['Bincode'].toString(),
            scanguid: errorScannedPostData[i]['scanguid'].toString(),
            devicecode: errorScannedPostData[i]['Devicecode'].toString(),
            checklist: [],
            ismanual: int.parse(errorScannedPostData[i]['IsManual'].toString()),
            errormsg: errorScannedPostData[i]['ApiErrorMsg'].toString(),
            itemCode: errorScannedPostData[i]['ItemCode'].toString(),
            notes: errorScannedPostData[i]['Notes'].toString(),
            quantity:
                double.parse(errorScannedPostData[i]['Quantity'].toString()),
            scandatetime: errorScannedPostData[i]['Scandatetime'].toString(),
            serialbatch: errorScannedPostData[i]['Serialbatch'].toString(),
            stockstatus: errorScannedPostData[i]['Stockstatus'].toString(),
            templateid: errorScannedPostData[i]['Templateid'] != null
                ? int.parse(errorScannedPostData[i]['Templateid'].toString())
                : 0,
            whscode: errorScannedPostData[i]['Whscode'].toString()));
        notifyListeners();
      }
    }
    notifyListeners();
  }

  callAuditapiwhilenetoff(BuildContext context, ThemeData theme) async {
    bool? noNetbool = await config.haveNoInterNet();
    if (noNetbool == false) {
      callGetAuditApi(context, theme);
      notifyListeners();
    } else {
      await getAuditBydeviceData();
    }
    notifyListeners();
  }

  bool againstart = false;

  groupSelectvalue(int i) {
    groupValueSelected = i;
    if (i == 0) {
      mycontroller[6].text = '';
      notifyListeners();
    } else {
      noteFocus.requestFocus();
    }
    notifyListeners();
  }

  bool viewerrors = false;
  bool viewsucess = false;
  bool viewmain = false;

  getAuditBydeviceData() async {
    getAuditList = [];
    openAuditList = [];
    completedAuditList = [];
    upcomingtAuditList = [];
    errorMsg = '';
    Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> result2 =
        await DBOperation.getAuditByDervice(db);
    if (result2.isNotEmpty) {
      getAuditList = [];
      openAuditList = [];
      completedAuditList = [];
      upcomingtAuditList = [];

      isLoading == false;
      for (var i = 0; i < result2.length; i++) {
        getAuditList.add(GetAuditDataModel(
            auditFrom: result2[i]['AuditFrom'].toString() ?? '',
            user: result2[i]['User'].toString(),
            percent: result2[i]['Percent'] != null
                ? double.parse(result2[i]['Percent'].toString())
                : 0,
            unitsScanned: result2[i]['UnitsScanned'] != null
                ? int.parse(result2[i]['UnitsScanned'].toString())
                : 0,
            totalItems: result2[i]['TotalItems'] != null
                ? int.parse(result2[i]['TotalItems'].toString())
                : 0,
            auditTo: result2[i]['AuditTo'].toString(),
            // blockTrans: bool.parse(result2[i][' blockTrans'].toString()),
            createdBy: result2[i]['CreatedBy'] != null
                ? int.parse(result2[i]['CreatedBy'].toString())
                : 0,
            createdDatetime: result2[i]['CreatedDatetime'].toString(),
            docDate: result2[i]['DocDate'].toString(),
            docEntry: result2[i]['DocEntry'] != null
                ? int.parse(result2[i]['DocEntry'].toString())
                : 0,
            docNum: result2[i]['DocNum'] != null
                ? int.parse(result2[i]['DocNum'].toString())
                : 0,
            endDate: result2[i]['EndDate'].toString(),
            remarks: result2[i]['Remarks'].toString(),
            // repeat: result2[i]['repeat'] != null
            //     ? bool.parse(result2[i]['repeat'].toString())
            //     : false,
            repeatDay: result2[i]['RepeatDay'] != null
                ? int.parse(result2[i]['RepeatDay'].toString())
                : 0,
            repeatFrequency: result2[i]['RepeatFrequency'].toString(),
            scheduleName: result2[i]['ScheduleName'].toString(),
            startDate: result2[i]['StartDate'].toString(),
            status: result2[i]['Status'].toString(),
            traceid: result2[i]['Traceid'].toString(),
            updatedBy: result2[i]['UpdatedBy'] != null
                ? int.parse(result2[i]['UpdatedBy'].toString())
                : 0,
            updatedDatetime: result2[i]['UpdatedDatetime'].toString(),
            whsCode: result2[i]['WhsCode'] != null
                ? result2[i]['WhsCode'].toString()
                : '',
            deviceCode: ''));
      }
    }
    splitAuditJob();
  }

  clearAllData() async {
    groupValueSelected = 0;
    totalScan = 0;
    totalScanPost = 0;
    viewSuccessDetails = [];
    viewScanMainDetails = [];
    pushedexcelvaluers = [];
    pendingexcelvaluers = [];
    errorexcelvaluers = [];
    viewsucess = false;
    viewmain = false;
    syncdatafreeze = false;
    totalSuccess = 0;
    totalError = 0;
    stockRecord = 0;
    totalscandeviceQty = 0;
    binRecord = 0;
    itemMasterRecord = 0;
    openAuditList = [];
    completedAuditList = [];
    viewerrorDetails = [];
    upcomingtAuditList = [];
    dispAllvalList = [];
    resetaudit = false;
    scandata = [];
    getAuditList = [];
    assignvalue = '';
    checklistdata = [];
    isLoading = true;
    seriesfocus = true;
    nextdisable = false;
    freezeItemCode = false;
    mycontroller = List.generate(20, (i) => TextEditingController());
    apidate = '';
    isClickedStart = false;
    isManualtype = false;
    errorMsg = '';
    freezeqty = false;
    mycontroller[6].text = '';
    isSelectedCusTag = '';
    itemCode = '';
    skuCosde = '';
    serialBatch = '';
    auditList = [];
    scanTime = '';
    dispvalList = [];

    notifyListeners();
  }

  Future imagetoBinary2(ImageSource source, BuildContext context) async {
    List<File> filesz = [];
    urlImage = '';
    // await LocationTrack.checkcamlocation();
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    log("image::$image");
    log("image22::${image.name}");
    // files.add(File());
    // if(filedata.isEmpty){
    filedata.clear();
    filesz.clear();
    // }
    filesz.add(File(image.path));

    log("filesz lenghthhhhh::::::${filedata.length}");
    if (files.length <= 4) {
      for (int i = 0; i < filesz.length; i++) {
        files.add(filesz[i]);
        List<int> intdata = filesz[i].readAsBytesSync();
        String fileName = filesz[i].path.split('/').last;
        String fileBytes = base64Encode(intdata);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String fullPath = '${tempDir.path}/$fileName';
        if (Platform.isAndroid) {
          filedata.add(
              FilesData(fileBytes: base64Encode(intdata), fileName: fullPath
                  // files[i].path.split('/').last
                  ));
        } else {
          filedata.add(
              FilesData(fileBytes: base64Encode(intdata), fileName: image.path
                  // files[i].path.split('/').last
                  ));
        }
        // filedata.add(FilesData(
        //     fileBytes: base64Encode(intdata),
        //     fileName: fullPath));
        log("filename::$fullPath");
        log("file path22222222::${filesz[i].path}");
        OrderAttachmentApiApi.getData(filesz[i].path).then((value) {
          log("valuevaluevalue::$value");
          urlImage = value;
          notifyListeners();
        });
        // callProfileUpdateApi1(filedata[i].fileName,image.name,context);
      }
      // log("filesz lenghthhhhh::::::" + filedata.length.toString());
      notifyListeners();

      // return null;
    } else {
      // showtoast();
    }
    log("camera fileslength${files.length}");
    log("camera filesdatalength${filedata.length}");
    notifyListeners();

    // showtoast();
  }

  imageBottomSheet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              SizedBox(
                  height: Screens.padingHeight(context) * 0.13,
                  width: Screens.width(context) * 0.35,
                  child: IconButton(
                    color: theme.primaryColor,
                    onPressed: () {
                      selectattachment(context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.image,
                      size: 60,
                    ),
                  )),
              SizedBox(
                  height: Screens.padingHeight(context) * 0.13,
                  width: Screens.width(context) * 0.4,
                  child: IconButton(
                    color: theme.primaryColor,
                    onPressed: () {
                      imagetoBinary2(ImageSource.camera, context);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 60,
                    ),
                  ))
            ],
          );
        },
      );
    }
  }

  disableKeyBoard(BuildContext context) {
    log('message un focusssss1111:::');
    FocusScope.of(context).unfocus();
    notifyListeners();
  }

  selectattachment(BuildContext context) async {
    List<File> filesz = [];
    urlImage = '';
    log(files.length.toString());
    log('filessssssssssssssssssssss');
    // result = await FilePicker.platform.pickFiles(allowMultiple: false);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      log("image::$result");
      log("image22::${result.names.remove}");

      String? urlimage = result.names[0];
      log("urlimage::$urlimage");
      // if(filedata.isEmpty){
      files.clear();
      filesz.clear();
      filedata.clear();
      // }

      log("filedata::${filedata.length}");

      filesz = result.paths.map((path) => File(path!)).toList();

      // if (filesz.length != 0) {
      //  int remainingSlots = 1 - files.length;
      if (filesz.length <= 1) {
        for (int i = 0; i < filesz.length; i++) {
          // createAString();

          // showtoast();
          files.add(filesz[i]);
          log("Files Lenght :::::${filesz[i].path}");
          List<int> intdata = filesz[i].readAsBytesSync();
          filedata.add(FilesData(
              fileBytes: base64Encode(intdata), fileName: filesz[i].path));
          notifyListeners();
          OrderAttachmentApiApi.getData(filesz[i].path).then((value) {
            log("valuevaluevalue::$value");
            urlImage = value;
            notifyListeners();
          });
          //New
          // XFile? photoCompressedFile =await testCompressAndGetFile(filesz[i],filesz[i].path);
          // await FileStorage.writeCounter('${photoCompressedFile!.name}_1', photoCompressedFile);
          //

          // callProfileUpdateApi1(
          //     filedata[i].fileName, urlimage.toString(), context);
          // log("filedata222::${filedata.length}");
          // return null;
        }
      } else {
        // showtoast();
        notifyListeners();
      }
      notifyListeners();
    }
  }

  selectCustomerTag(String code) {
    isSelectedCusTag = '';
    isSelectedCusTag = code;
    notifyListeners();
  }

  selectFirstTapVal() {
    if (dispvalList.isNotEmpty) {
      isSelectedCusTag = dispvalList[0].dispListVal.toString();
      notifyListeners();
    }
  }

  List<Widget> listContainersCustomertags(
      ThemeData theme, BuildContext context) {
    return List.generate(
        dispvalList.length,
        (index) => InkWell(
              onTap: () {
                selectCustomerTag(dispvalList[index].dispListVal.toString());
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isSelectedCusTag ==
                            dispvalList[index].dispListVal.toString()
                        ? theme.primaryColor.withOpacity(0.2)
                        : Colors.white,
                    border: Border.all(color: theme.primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(dispvalList[index].dispListVal.toString(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: isSelectedCusTag ==
                              dispvalList[index].dispListVal.toString()
                          ? theme.primaryColor //,Colors.white
                          : theme.primaryColor,
                    )),
              ),
            ));
  }

  fetchOpenDetails(GetAuditDataModel fetchAuditDetais2) {
    fetchAuditForDetails = FetchAuditDetais(
        totalItems: fetchAuditDetais2.totalItems,
        unitsScanned: fetchAuditDetais2.unitsScanned,
        auditFrom: fetchAuditDetais2.auditFrom,
        deviceCode: fetchAuditDetais2.deviceCode,
        user: fetchAuditDetais2.user,
        auditTo: fetchAuditDetais2.auditTo,
        blockTrans: fetchAuditDetais2.blockTrans,
        createdBy: fetchAuditDetais2.createdBy,
        createdDatetime: fetchAuditDetais2.createdDatetime,
        docDate: fetchAuditDetais2.docDate,
        docEntry: fetchAuditDetais2.docEntry,
        percent: fetchAuditDetais2.percent,
        docNum: fetchAuditDetais2.docNum,
        endDate: fetchAuditDetais2.endDate,
        remarks: fetchAuditDetais2.remarks,
        repeat: fetchAuditDetais2.repeat,
        repeatDay: fetchAuditDetais2.repeatDay,
        repeatFrequency: fetchAuditDetais2.repeatFrequency,
        scheduleName: fetchAuditDetais2.scheduleName,
        startDate: fetchAuditDetais2.startDate,
        status: fetchAuditDetais2.status,
        traceid: fetchAuditDetais2.traceid,
        updatedBy: fetchAuditDetais2.updatedBy,
        updatedDatetime: fetchAuditDetais2.updatedDatetime,
        whsCode: fetchAuditDetais2.whsCode);
    log('XXXXX:::${fetchAuditForDetails.docEntry}');
  }

  String errorMsg = '';
  String NoDataMsg = 'No Data Found..!!';

  String? deviceId = '';
  callGetAuditApi(BuildContext context, ThemeData theme) async {
    // final theme = Theme.of(context);
    Database db = (await DBHelper.getInstance())!;
    getAuditList2 = [];
    openAuditList = [];
    completedAuditList = [];
    upcomingtAuditList = [];
    errorMsg = '';
    isLoading = true;

    deviceId = await HelperFunctions.getDeviceIDSharedPreference();
    await GetAuditByDeviceApi.getData(deviceId!).then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        // log('value.auditData lengyth::${value.auditData.length}');
        getAuditList = [];
        DBOperation.truncateAuditByDevice(db);
        getAuditList2 = value.auditData;
        DBOperation.insertAuditByDervice(db, getAuditList2);
        List<Map<String, Object?>> result2 =
            await DBOperation.getAuditByDervice(db);
        if (result2.isNotEmpty) {
          for (var i = 0; i < result2.length; i++) {
            getAuditList.add(GetAuditDataModel(
                auditFrom: result2[i]['AuditFrom'].toString(),
                user: result2[i]['User'].toString(),
                percent: result2[i]['Percent'] != null
                    ? double.parse(result2[i]['Percent'].toString())
                    : 0,
                unitsScanned: result2[i]['UnitsScanned'] != null
                    ? int.parse(result2[i]['UnitsScanned'].toString())
                    : 0,
                totalItems: result2[i]['TotalItems'] != null
                    ? int.parse(result2[i]['TotalItems'].toString())
                    : 0,
                auditTo: result2[i]['AuditTo'].toString(),
                // blockTrans: bool.parse(result2[i][' blockTrans'].toString()),
                createdBy: result2[i]['CreatedBy'] != null
                    ? int.parse(result2[i]['CreatedBy'].toString())
                    : 0,
                createdDatetime: result2[i]['CreatedDatetime'].toString(),
                docDate: result2[i]['DocDate'].toString(),
                docEntry: result2[i]['DocEntry'] != null
                    ? int.parse(result2[i]['DocEntry'].toString())
                    : 0,
                docNum: result2[i]['DocNum'] != null
                    ? int.parse(result2[i]['DocNum'].toString())
                    : 0,
                endDate: result2[i]['EndDate'].toString(),
                remarks: result2[i]['Remarks'].toString(),
                // repeat: result2[i]['repeat'] != null
                //     ? bool.parse(result2[i]['repeat'].toString())
                //     : false,
                repeatDay: result2[i]['RepeatDay'] != null
                    ? int.parse(result2[i]['RepeatDay'].toString())
                    : 0,
                repeatFrequency: result2[i]['RepeatFrequency'].toString(),
                scheduleName: result2[i]['ScheduleName'].toString(),
                startDate: result2[i]['StartDate'].toString(),
                status: result2[i]['Status'].toString(),
                traceid: result2[i]['Traceid'].toString(),
                updatedBy: result2[i]['UpdatedBy'] != null
                    ? int.parse(result2[i]['UpdatedBy'].toString())
                    : 0,
                updatedDatetime: result2[i]['UpdatedDatetime'].toString(),
                whsCode: result2[i]['WhsCode'] != null
                    ? result2[i]['WhsCode'].toString()
                    : '',
                deviceCode: ''));
          }
        }
        isLoading = false;
        // log('getAuditList::${getAuditList.length}');
        splitAuditJob();
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        errorMsg = value.exception;
        isLoading = false;
        apiResponseDialog(context, theme, errorMsg);
        notifyListeners();
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Check Your Internet..!!'),
          backgroundColor: Colors.red,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
          dismissDirection: DismissDirection.up,
        ));
        notifyListeners();
      }
    });
    notifyListeners();
  }

  getCheckListForm() async {
    getckeckDataListForm = [];
    final database = (await AppDatabase.initialize())!;
    getckeckDataListForm =
        await driftoperation.getcheckListLineMasterdata(database);
    notifyListeners();
  }

  final List<String> _tags = [];

  void addTag(String tag) {
    _tags.add(tag);
    notifyListeners();
  }

  List<CheckListLineData> getckeckDataListForm55 = [];
  checkListformCreation(BuildContext context, ThemeData theme, int dispnum) {
    List<String> listval = [];
    files = [];

    if (getckeckDataListForm.isNotEmpty) {
      getckeckDataListForm55 = [];
      checklistdata = [];

      for (var i = 0; i < getckeckDataListForm.length; i++) {
        if (getckeckDataListForm[i].docEntry == dispnum) {
          getckeckDataListForm55.add(CheckListLineData(
              checklistName: getckeckDataListForm[i].checklistName,
              acceptAttach: getckeckDataListForm[i].acceptAttach,
              acceptMultiValue: getckeckDataListForm[i].acceptMultiValue,
              checklistCode: getckeckDataListForm[i].checklistCode,
              createdBy: getckeckDataListForm[i].createdBy,
              createdDatetime: getckeckDataListForm[i].createdDatetime,
              docEntry: getckeckDataListForm[i].docEntry,
              // docEntry1: getckeckDataListForm[i].docEntry1,
              isMandaory: getckeckDataListForm[i].isMandaory,
              listValue: getckeckDataListForm[i].listValue,
              isselectlistval: '',
              templateName: getckeckDataListForm[i].templateName,
              traceid: getckeckDataListForm[i].traceid,
              updatedBy: getckeckDataListForm[i].updatedBy,
              updatedDatetime: getckeckDataListForm[i].updatedDatetime));
        }
        notifyListeners();
      }
      showingChecklistBottomSheet(context, theme);
    }
    notifyListeners();
  }

  String isSelectMethod(List<CheckListselect> chklistttt, String val) {
    log('vallllll:$val');
    // log('val2:' + chklistttt[0].listval.toString());
    // log('val3:' + chklistttt[1].listval.toString());
    if (val.isEmpty) {
      return '';
    } else {
      var result = chklistttt.where((test) => test.listval == val);
      List result2 = result.toList();
      if (result2.isEmpty) {
        return val;
      } else {
        return '';
      }
    }
  }

  List<String> selectedassignto = [];
  String? assignvalue = '';
  bool isselected = false;
  itemselectassignto(
    String itemvalue,
  ) {
    log('itemvalueitemvalue:$itemvalue');
    // if (selectionTag == true) {
    log(selectedassignto.toString());
    selectedassignto.add(
      itemvalue,
    );
    // } else {
    //   selectedassignto.remove(itemvalue);
    // }
    assignvalue = selectedassignto.join(', ');
    log('assignvalueassignvalue:${assignvalue!.toString()}');
    notifyListeners();
  }

  var selectAnsx = '';

  onTapCheckListVal(ij, String selectedchecklistval) {
    if (checklistdata.isEmpty) {
      checklistdata.add(DispListData(
          scanguid: '',
          attachurl: '',
          auditid: fetchAuditForDetails.docEntry,
          checklistcode: getckeckDataListForm55[ij].checklistCode,
          checklistvalue: selectedchecklistval));
      notifyListeners();
    } else {
      for (int i = 0; i < checklistdata.length; i++) {
        if (checklistdata[i].checklistcode ==
            getckeckDataListForm55[ij].checklistCode) {
          log(' getckeckDataListForm55[ij].checklistCode::${getckeckDataListForm55[ij].checklistCode}::'
              '${checklistdata[i].checklistcode}');
          checklistdata[i].checklistvalue = selectedchecklistval;
          notifyListeners();
        } else {
          log('mkmkmkmkmkmkmk');
          checklistdata.add(DispListData(
              scanguid: '',
              attachurl: '',
              auditid: fetchAuditForDetails.docEntry,
              //  getckeckDataListForm55[ij].docEntry,
              checklistcode: getckeckDataListForm55[ij].checklistCode,
              checklistvalue: selectedchecklistval));
          notifyListeners();
        }
        break;
      }
      notifyListeners();
    }
    log('checklistdatachecklistdata length::${checklistdata.length}');

    // if (isselected == true) {
    //   log('ccccccccccc');
    //   log('isselect:::${getckeckDataListForm55[i].isselectlistval.toString()}');
    //   isselected = false;
    //   notifyListeners();
    // } else if (isselected == false) {
    //   log('dddddddddd');
    //   isselected = true;
    //   log('isselect:::${getckeckDataListForm55[i].isselectlistval.toString()}');

    //   notifyListeners();
    // }
  }

  showingChecklistBottomSheet(
    BuildContext context,
    ThemeData theme,
  ) {
    assignvalue = '';
    List<String> selectAns = [];
    List<CheckListselect> chklisttttx = [];
    int? i;
    selectAnsx = '';
    selectedassignto = [];
    log('assignvalueassignvaluezzz::$assignvalue');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setSt) {
            return GetImageFilePage();
          });
        });
  }

  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode noteFocus = FocusNode();
  FocusNode itemFocus = FocusNode();

  static const platform = MethodChannel('com.buson.verifytapp/time');
  String networkTimeStatus = '';
  Future<void> _openDateTimeSettings(BuildContext context) async {
    Get.back();
    try {
      await platform.invokeMethod('openDateTimeSettings');
      // Wait for a short time to allow settings to be applied.
      await Future.delayed(const Duration(seconds: 1));
      // Recheck the status after navigating to settings.
      _checkAutomaticTimeZoneSetting(context);
    } on PlatformException catch (e) {
      log('$e');
      // Handle error if needed
    }
  }

  void didChangeAppLifecycleState(
      AppLifecycleState state, BuildContext context) {
    if (state == AppLifecycleState.resumed) {
      _checkAutomaticTimeZoneSetting(context);
    }
  }

  Future<void> _checkAutomaticTimeZoneSetting(BuildContext context) async {
    bool isAutomatic;
    String networkTimeStatuss = '';
    networkTimeStatus = '';
    try {
      isAutomatic = await platform.invokeMethod('checkNetworkTime');
      networkTimeStatuss = isAutomatic ? 'Enabled' : 'Disabled';
      networkTimeStatus = networkTimeStatuss;

      if (networkTimeStatus == 'Enabled') {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Automatic time zone is already enabled.'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      } else if (networkTimeStatus == 'Disabled') {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content:
                    const Text('Enable Network-Provided Time on Your Device '),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _openDateTimeSettings(context);
                      },
                      child: const Text('OK'))
                ],
              );
            });
      }
    } on PlatformException catch (e) {
      log('${e}');
      isAutomatic = false;
    }
  }

  callTimeEnableMethod(BuildContext context) {
    // WidgetsBinding.instance.addObserver(this);
    networkTimeStatus = '';
    _checkAutomaticTimeZoneSetting(context);
  }

  bottomSheetafterscanserial(
    BuildContext context,
    ThemeData theme,
  ) async {
    final database = (await AppDatabase.initialize())!;

    focus1.unfocus();
    focus2.unfocus();

    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setSt) {
            return SerialBatchDetails();
          });
        });
    int offline = whileOffline == true ? 1 : 0;
    log('dispCode.toString()dispCode.toString()::${dispCode.toString()}');
    List<Checklisttemplate> checklistvalx = await driftoperation.checkListPopup(
        database, mycontroller[3].text, dispCode.toString(), 1, 0);

    if (checklistvalx.isNotEmpty) {
      for (var i = 0; i < checklistvalx.length; i++) {
        if (checklistvalx[i].templateid != null) {
          checkListformCreation(context, theme,
              int.parse(checklistvalx[i].templateid.toString()));
          notifyListeners();
        }
      }

      notifyListeners();
    }
  }

  checkTableEmpty(
    BuildContext context,
    ThemeData theme,
    String apiRes,
    String actionName,
    int docEntry,
    int indx,
  ) async {
    againstart = true;
    notifyListeners();
    final database = (await AppDatabase.initialize())!;

    List<LoadItemCodeLists> getItemCoderesult =
        await driftoperation.getItemCodeMasterdata(database, docEntry);

    if (getItemCoderesult.isNotEmpty) {
      againstart = false;
      actionResetDialog(
        context,
        theme,
        apiRes,
        actionName,
        docEntry,
        indx,
      );
      notifyListeners();
      // List<LineData> getlineresult22 =
      //     await driftoperation.getallLineproduct(database);
      // log('getlineresult222 length::${getlineresult22.length}');
    } else {
      String mssgg2 =
          'This Operation may take few minutes. Closing the application may interrupt the process. \nDo you want to continue ?';
      actionwarningDialog(context, theme, mssgg2, 'Start', docEntry, indx);
    }
    notifyListeners();
  }

  void callGetItemCodeApi(
      BuildContext context, ThemeData theme, int docEntry, int indx) async {
    Get.back();
    Database db = (await DBHelper.getInstance())!;
    final database = (await AppDatabase.initialize())!;
    auditActionHeaderList = [];
    auditActionLineList = [];
    errorMsg = '';

    await GetItemCodeMasterApi.getData(docEntry).then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        itemCodeList = value.auditData;

        if (itemCodeList.isNotEmpty) {
          await driftoperation.insertdriftitemcodedb(itemCodeList, database);
        }
        notifyListeners();
        List<LoadItemCodeLists> getItemCodeResult =
            await driftoperation.getItemCodeMasterAlldata(database);
        if (getItemCodeResult.isNotEmpty) {
          String lastdowntime = config.firstDate();
          lastdowntimeStamp = config.aligndateforTimeStampt(lastdowntime);
          await LoadCompleteDataApi.getData(docEntry).then((valuex) async {
            if (valuex.stsCode == 200) {
              log('Successsssss1111');

              await callGetAuditApi(context, theme);
              await Get.defaultDialog(
                  title: 'Success',
                  content: Column(
                    children: [
                      Text('Data downloaded successfully'),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              foregroundColor: Colors.white,
                              backgroundColor: theme.primaryColor),
                          onPressed: () async {
                            openAuditList[indx].isStarting = false;
                            Get.back();
                          },
                          child: const Text(' Ok '))
                    ],
                  ));

              notifyListeners();
            } else {
              log('Successsssss222222');
              openAuditList[indx].isStarting = false;
              await Get.defaultDialog(
                  title: 'Message',
                  content: Column(
                    children: [
                      Text('${valuex.respCode}..!! ${valuex.respDesc}'),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              foregroundColor: Colors.white,
                              backgroundColor: theme.primaryColor),
                          onPressed: () async {
                            openAuditList[indx].isStarting = false;
                            Get.back();
                          },
                          child: const Text(' Ok '))
                    ],
                  ));
              log('Successsssss55555');
              notifyListeners();
            }
          });
          notifyListeners();
        }
        openAuditList[indx].isStarting = false;

        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        openAuditList[indx].isStarting = false;
        errorMsg = value.exception;
        apiResponseDialog(context, theme, value.exception);
        await Get.defaultDialog(
            title: 'Alert',
            content: Column(
              children: [
                Text('${value.exception}'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        foregroundColor: Colors.white,
                        backgroundColor: theme.primaryColor),
                    onPressed: () {
                      Get.back();
                      // context.read<DashBoardCtrlProvider>().selectedIndex =
                      //     1;
                      // Get.offAllNamed(ConstantRoutes.dashboard);
                    },
                    child: const Text(' Ok '))
              ],
            ));

        isLoading = false;
        notifyListeners();
      } else {
        openAuditList[indx].isStarting = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Check Your Internet..!!'),
          backgroundColor: Colors.red,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
          dismissDirection: DismissDirection.up,
        ));
      }
    });
    notifyListeners();
  }

  void callGetAuditActionApi(BuildContext context, ThemeData theme,
      String actionName, int docEntry, int indx) async {
    Get.back();
    Database db = (await DBHelper.getInstance())!;
    final database = (await AppDatabase.initialize())!;
    auditActionHeaderList = [];
    auditActionLineList = [];
    errorMsg = '';

    await GetAuditActionApi.getData(actionName, docEntry).then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        auditActionHeaderList = value.auditData!.auditHeaderData;
        auditActionLineList = value.auditData!.auditLineData;
        auditActionBinMasterList = value.auditData!.binMassterList;

        if (auditActionHeaderList.isNotEmpty) {
          await driftoperation.insertdriftdatabase(
              auditActionHeaderList, database);
        }
        if (auditActionLineList.isNotEmpty) {
          await driftoperation.insertdriftLinedatabase(
              auditActionLineList, database);
        }
        if (auditActionBinMasterList.isNotEmpty) {
          await driftoperation.insertBinMasterdatabase(
              auditActionBinMasterList, database);
        }
        notifyListeners();

        List<LineData> getlineresult =
            await driftoperation.getallLineproduct(database);
        List<HeaderData> getheaderresult =
            await driftoperation.getallproduct(database);
        List<BinMasterData> getbinresult =
            await driftoperation.getBinMasterdata(database);
        log('headerresult::${getheaderresult.length}::lineresult::${getlineresult.length}:::BinResult::${getbinresult.length}');
        if (getheaderresult.isNotEmpty ||
            getlineresult.isNotEmpty ||
            getbinresult.isNotEmpty) {
          String lastdowntime = config.firstDate();
          lastdowntimeStamp = config.aligndateforTimeStampt(lastdowntime);
          // viewLoadDetails.add(ViewDetailsData(
          //     binlength: getbinresult.length,
          //     itemlength: getlineresult.length,
          //     docEntry: docEntry,
          //     lasttimestamp: lastdowntimeStamp.toString(),
          //     stocklength: getheaderresult.length));
          await LoadCompleteDataApi.getData(docEntry).then((valuex) async {
            if (valuex.stsCode == 200) {
              await callGetAuditApi(context, theme);

              log('Successsssss1111');
              await Get.defaultDialog(
                  title: 'Success',
                  content: Column(
                    children: [
                      Text('Data downloaded successfully'),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              foregroundColor: Colors.white,
                              backgroundColor: theme.primaryColor),
                          onPressed: () async {
                            openAuditList[indx].isStarting = false;
                            Get.back();
                          },
                          child: const Text(' Ok '))
                    ],
                  ));
              notifyListeners();
            } else {
              log('Successsssss222222');
              openAuditList[indx].isStarting = false;
              apiResponseDialog(context, theme, valuex.respDesc);
              log('Successsssss55555');
              notifyListeners();
            }
          });
          notifyListeners();
        }
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        openAuditList[indx].isStarting = false;
        errorMsg = value.exception;
        // apiResponseDialog(context, theme, value.exception);
        await Get.defaultDialog(
            title: 'Alert',
            content: Column(
              children: [
                Text('${value.exception}'),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        foregroundColor: Colors.white,
                        backgroundColor: theme.primaryColor),
                    onPressed: () {
                      Get.back();
                      // context.read<DashBoardCtrlProvider>().selectedIndex =
                      //     1;
                      // Get.offAllNamed(ConstantRoutes.dashboard);
                    },
                    child: const Text(' Ok '))
              ],
            ));

        isLoading = false;
        notifyListeners();
      } else {
        openAuditList[indx].isStarting = false;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Check Your Internet..!!'),
          backgroundColor: Colors.red,
          elevation: 10,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(5),
          dismissDirection: DismissDirection.up,
        ));
      }
    });
    notifyListeners();
  }

  AudioPlayer? audioPlayer;

  void playAudio(String assetPath) async {
    await audioPlayer!.play(AssetSource(assetPath));
    notifyListeners();
  }

  afterScanbinCode(BuildContext context, ThemeData theme, String columnName,
      String binValues) async {
    final database = (await AppDatabase.initialize())!;
    // Database db = (await DBHelper.getInstance())!;
    listScanBatch = await driftoperation.getdriftallLineColumn(
        database, columnName, binValues);
    List<BinMasterData> checkBin =
        await driftoperation.checkBinMasterdata(database, binValues);
    mycontroller[2].text = binValues;

    // List<Map<String, Object?>> result2 =
    //     await DBOperation.checkBinInAuditLineData(db, columnName, binValues);
    if (listScanBatch.isNotEmpty || checkBin.isNotEmpty) {
      callBinBlockApi(context, theme, binValues);
      seriesfocus = false;
      focus2.requestFocus();
      // disableKeyBoard(context);
      log('AudioPlayAudioPlay');
      // /D/Sharmila/verifytapp/asset/sounds/bin_selection.mp3
      // play
      // Audio('sounds/bin_selection.mp3');
    }
    notifyListeners();
    if (listScanBatch.isEmpty && checkBin.isEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8))),
                  width: Screens.width(context) * 0.8,
                  height: Screens.padingHeight(context) * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Screens.width(context) * 0.8,
                        alignment: Alignment.center,
                        child: Center(
                            child: Text("Alert",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.02,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: Screens.width(context) * 0.8,
                  child: const Text(
                      'Scanned bin is not in the stock table and item master table'),
                ),
                SizedBox(
                  height: Screens.padingHeight(context) * 0.02,
                ),
                SizedBox(
                  width: Screens.width(context) * 0.8,
                  height: Screens.padingHeight(context) * 0.06,
                  child: ElevatedButton(
                      onPressed: () async {
                        mycontroller[2].text = '';
                        Get.back();
                        focus1.requestFocus();
                        notifyListeners();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        )),
                      ),
                      child: const Text("Ok")),
                ),
              ],
            ),
          );
        },
      );
    }
    notifyListeners();
  }

  onChangetext(String newval) {
    String val = newval;
    mycontroller[3].clear();
    mycontroller[3].text = val;
    notifyListeners();
  }

  clearbtn() {
    scandata = [];
    checklistdata = [];
    skuCosde = '';
    itemCode = '';
    scanTime = '';
    itemName = '';
    dispCode = null;
    groupValueSelected = 0;
    serialBatch = '';
    mycontroller[3].text = '';
    mycontroller[4].text = '';
    mycontroller[5].text = '';
    mycontroller[6].text = '';
    isManualtype = false;
    dispvalList = [];
    focus2.requestFocus();
    notifyListeners();
  }

  afterScanMultiSerialBatch(List<LineData> multiLineItemResult,
      BuildContext context, ThemeData theme) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                insetPadding: EdgeInsets.all(8),
                content: Container(
                    height: Screens.padingHeight(context) * 0.4,
                    width: Screens.width(context),
                    child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: multiLineItemResult.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 0,
                              child: GestureDetector(
                                onTap: () async {
                                  Get.back();
                                  getMultiItemDetails(
                                      multiLineItemResult[index]
                                          .itemCode
                                          .toString(),
                                      multiLineItemResult[index]
                                          .serailBatch
                                          .toString());
                                  await bottomSheetafterscanserial(
                                      context, theme);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(
                                      Screens.padingHeight(context) * 0.008),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.black26)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(multiLineItemResult[index]
                                          .itemCode
                                          .toString()),
                                      Text(multiLineItemResult[index]
                                          .serailBatch
                                          .toString()),
                                    ],
                                  ),
                                ),
                              ));
                        })));
          });
        });
    notifyListeners();
  }

  afterScanSerialBatch(
    BuildContext context,
    ThemeData theme,
    String scanbatchval,
  ) async {
    nextdisable = false;
    final database = (await AppDatabase.initialize())!;
    Database db = (await DBHelper.getInstance())!;
    List<LineData> getLineItemResult = await driftoperation
        .getdriftallserialLineColumn(database, scanbatchval);
    List<LineData> alterlineItemResult =
        await driftoperation.geAlterserialLineColumn(database, scanbatchval);

    if (getLineItemResult.isNotEmpty) {
      if (getLineItemResult.length > 1) {
        log('lineItemResultlineItemResult::${getLineItemResult.length}');
        await afterScanMultiSerialBatch(getLineItemResult, context, theme);
        notifyListeners();
      } else {
        await afterScanSingleSerialBatch(
            context, theme, scanbatchval, getLineItemResult);
        await bottomSheetafterscanserial(context, theme);
        notifyListeners();
      }
    }
    if (getLineItemResult.isEmpty && alterlineItemResult.isEmpty) {
      mycontroller[4].text = '';
      freezeItemCode = false;
      itemFocus.requestFocus();
      mycontroller[3].text = scanbatchval;
      mycontroller[5].text = 1.toString();
      await bottomSheetafterscanserial(context, theme);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    width: Screens.width(context) * 0.8,
                    height: Screens.padingHeight(context) * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: Screens.width(context) * 0.8,
                          child: Center(
                              child: Text("Alert",
                                  style: theme.textTheme.bodyLarge!
                                      .copyWith(color: Colors.white))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.02,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: Screens.width(context) * 0.8,
                    child: const Text(
                        'Scanned number is not in the stock snap table..!!'),
                  ),
                  SizedBox(
                    height: Screens.padingHeight(context) * 0.02,
                  ),
                  SizedBox(
                    width: Screens.width(context) * 0.8,
                    height: Screens.padingHeight(context) * 0.06,
                    child: ElevatedButton(
                        onPressed: () async {
                          st(
                            () {
                              scandata = [];
                              itemFocus.requestFocus();
                              freezeqty = false;
                              mycontroller[3].selection = TextSelection(
                                baseOffset: 0,
                                extentOffset: mycontroller[3].text.length,
                              );
                            },
                          );
                          Get.back();

                          notifyListeners();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                        ),
                        child: const Text("Ok")),
                  ),
                ],
              ),
            );
          });
        },
      );
    }

    if (alterlineItemResult.isNotEmpty) {
      freezeItemCode = true;
      if (alterlineItemResult.length > 1) {
        await afterScanMultiSerialBatch(alterlineItemResult, context, theme);
      } else {
        scanbatchval = alterlineItemResult[0].serailBatch!;
        await afterScanSingleSerialBatch(
            context, theme, scanbatchval, alterlineItemResult);
        await bottomSheetafterscanserial(context, theme);
      }

      // for (var i = 0; i < alterlineItemResult.length; i++) {
      // itemCode = alterlineItemResult[0].itemCode!;
      // dispCode = alterlineItemResult[0].itemDisposition;
      // mycontroller[3].text = alterlineItemResult[0].serailBatch!;
      // mycontroller[4].text = alterlineItemResult[0].itemCode!;
      //   for (var ik = 0; ik < dispAllvalList.length; ik++) {
      //     if (alterlineItemResult[i].itemDisposition ==
      //         dispAllvalList[ik].dispID) {}
      //   }
      // }
    }
    mycontroller[3].selection = TextSelection(
      baseOffset: 0,
      extentOffset: mycontroller[3].text.length,
    );
    notifyListeners();
  }

  getSingleItemDetails(
      List<LineData> lineItemResult, String scanbatchval) async {
    itemCode = '';
    skuCosde = '';
    dispvalList = [];
    scandata = [];
    scanTime = '';
    mycontroller[6].text = '';
    isSelectedCusTag = '';
    groupValueSelected = 0;
    mangedBy = '';
    String? whsCode = '';
    // whsCode = await HelperFunctions.getWhsCode();
    final database = (await AppDatabase.initialize())!;
    Database db = (await DBHelper.getInstance())!;

    freezeItemCode = true;
    // playAudio('sounds/scan_serial_correct.mp3');
    // for (var i = 0; i < lineItemResult.length; i++) {
    if (lineItemResult[0].serailBatch!.toLowerCase() ==
        scanbatchval.toLowerCase()) {
      itemCode = lineItemResult[0].itemCode!;
      dispCode = lineItemResult[0].itemDisposition;
      mycontroller[3].text = lineItemResult[0].serailBatch!;
      mycontroller[4].text = lineItemResult[0].itemCode!;
      for (var ik = 0; ik < dispAllvalList.length; ik++) {
        if (lineItemResult[0].itemDisposition == dispAllvalList[ik].dispID) {}
      }
    }

    serialBatch = scanbatchval;
    itemCode = mycontroller[4].text;
    scanTime = config.currentDatepdf();
    mycontroller[5].text = 1.toString();

    List<LoadItemCodeLists> itemCodeResult =
        await driftoperation.getItemCodedata(database, itemCode);

    List<HeaderData> headeItemResult =
        await driftoperation.getItemCodeInHeader(database, itemCode);

    log('headeItemResultheadeItemResult::${headeItemResult.length}');
    if (headeItemResult.isNotEmpty && itemCodeResult.isNotEmpty) {
      if (headeItemResult[0].itemCode == itemCodeResult[0].itemCode) {
        log('manageby:${headeItemResult[0].manageBy}');
        skuCosde = headeItemResult[0].sKUCode.toString();
        itemName = headeItemResult[0].itemName.toString();
        dispCode = headeItemResult[0].itemDisposition;
        mycontroller[4].text = headeItemResult[0].itemCode.toString();
        mangedBy = headeItemResult[0].manageBy;
        log('headeItemResult[0].dispID::${headeItemResult[0].itemDisposition}');
        List<Map<String, Object?>> dispResult2 =
            await DBOperation.getAllDispDataList(
                db, headeItemResult[0].itemDisposition);
        for (var im = 0; im < dispResult2.length; im++) {
          dispvalList.add(GetDisPositonList(
              dispID: int.parse(dispResult2[im]['DispID'].toString()),
              dispListVal: dispResult2[im]['DisPositionVal'] != null
                  ? dispResult2[im]['DisPositionVal'].toString()
                  : ''));
        }
        if (dispvalList.isNotEmpty) {
          selectFirstTapVal();
        }

        if (headeItemResult[0].manageBy == "S") {
          freezeqty = true;
          notifyListeners();
        } else {
          freezeqty = false;
          notifyListeners();
        }
        log('headeItemResult[0].manageByheadeItemResult[0].manageBy::${headeItemResult[0].manageBy}');
      }
    }
  }

  getMultiItemDetails(String itemCodex, String scanbatchval) async {
    itemCode = '';
    skuCosde = '';
    dispvalList = [];
    scandata = [];
    scanTime = '';
    mycontroller[6].text = '';
    isSelectedCusTag = '';
    groupValueSelected = 0;
    mangedBy = '';
    String? whsCode = '';
    // whsCode = await HelperFunctions.getWhsCode();
    final database = (await AppDatabase.initialize())!;
    Database db = (await DBHelper.getInstance())!;

    freezeItemCode = true;
    // playAudio('sounds/scan_serial_correct.mp3');
    // for (var i = 0; i < lineItemResult.length; i++) {

    mycontroller[3].text = scanbatchval;
    mycontroller[4].text = itemCodex;

    // }

    serialBatch = scanbatchval;
    itemCode = mycontroller[4].text;
    scanTime = config.currentDatepdf();
    mycontroller[5].text = 1.toString();

    List<LoadItemCodeLists> itemCodeResult =
        await driftoperation.getItemCodedata(database, itemCode);

    List<HeaderData> headeItemResult =
        await driftoperation.getItemCodeInHeader(database, itemCode);

    log('headeItemResultheadeItemResult::${headeItemResult.length}');
    if (headeItemResult.isNotEmpty && itemCodeResult.isNotEmpty) {
      if (headeItemResult[0].itemCode == itemCodeResult[0].itemCode) {
        log('manageby:${headeItemResult[0].manageBy}');
        skuCosde = headeItemResult[0].sKUCode.toString();
        itemName = headeItemResult[0].itemName.toString();
        dispCode = headeItemResult[0].itemDisposition;
        mycontroller[4].text = headeItemResult[0].itemCode.toString();
        mangedBy = headeItemResult[0].manageBy;
        log('headeItemResult[0].dispID::${headeItemResult[0].itemDisposition}');
        List<Map<String, Object?>> dispResult2 =
            await DBOperation.getAllDispDataList(
                db, headeItemResult[0].itemDisposition);
        for (var im = 0; im < dispResult2.length; im++) {
          dispvalList.add(GetDisPositonList(
              dispID: int.parse(dispResult2[im]['DispID'].toString()),
              dispListVal: dispResult2[im]['DisPositionVal'] != null
                  ? dispResult2[im]['DisPositionVal'].toString()
                  : ''));
        }
        if (dispvalList.isNotEmpty) {
          selectFirstTapVal();
        }

        if (headeItemResult[0].manageBy == "S") {
          freezeqty = true;
          notifyListeners();
        } else {
          freezeqty = false;
          notifyListeners();
        }
        log('headeItemResult[0].manageByheadeItemResult[0].manageBy::${headeItemResult[0].manageBy}');
      }
    }
  }

  afterScanSingleSerialBatch(BuildContext context, ThemeData theme,
      String scanbatchval, List<LineData> lineItemResult) async {
    await getSingleItemDetails(lineItemResult, scanbatchval);
    notifyListeners();
  }

  setURL() async {
    String? getCustUrl = await HelperFunctions.getHostDSP();
    String? getStockUrl = await HelperFunctions.getStockHostDSP();

    log('getStockUrlget11:$getStockUrl');
    Url.queryApi = "${getCustUrl.toString()}/api/";
    Url.stockSnapApi = "${getStockUrl.toString()}/api/";
    log('  Url.queryApi Url.queryApi333::${Url.queryApi}:::stockSnapApi::${Url.stockSnapApi}');
    notifyListeners();
  }

  checknextbtn(BuildContext context, ThemeData theme, String serialbtch,
      String itemcode) async {
    Database db = (await DBHelper.getInstance())!;
    notifyListeners();
    log('scandatascandatanext::${scandata.length}');
    log('isManualtype::${isManualtype}');
    if (scandata.isNotEmpty) {
      if (mangedBy == 'S') {
        callNextBtnMethod(context, theme, serialbtch, itemcode);
        notifyListeners();
      } else {
        String uuiDeviceId = uuid.v1();
        scandata[0].scanguid = uuiDeviceId;

        if (checklistdata.isNotEmpty) {
          for (var i = 0; i < checklistdata.length; i++) {
            checklistdata[i].scanguid = uuiDeviceId;
          }
          await DBOperation.insertchecklistData(db, checklistdata).then(
            (value) {
              checklistdata = [];
            },
          );
          notifyListeners();
        }

        await DBOperation.insertscanpostData(db, scandata).then((value) {
          focus2.requestFocus();
          nextdisable = false;
          totalscandeviceQty = 0;
          mycontroller[3].text = '';
          binTableDetails(mycontroller[2].text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Scanned data inserted successfully..!'),
              backgroundColor: Colors.green,
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(5),
              dismissDirection: DismissDirection.up,
            ),
          );
          notifyListeners();
        });
        notifyListeners();

        scandata = [];
        mycontroller[3].text = '';
        mycontroller[4].text = '';
        mycontroller[5].text = '';
        groupValueSelected = 0;
        mycontroller[6].text = '';
        skuCosde = '';
        itemCode = '';
        scanTime = '';
        itemName = '';
        serialBatch = '';
        dispAllvalList = [];
        isManualtype = false;
        selectFirstTapVal();
        notifyListeners();
      }
    }

    await scantotaldeviceqty();
    Get.back();
    notifyListeners();
  }

  callNextBtnMethod(BuildContext context, ThemeData theme, String srialbtchx,
      String itemcodex) async {
    Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> result2 = await DBOperation.getscandataData(db);
    List<Map<String, Object?>> result3 =
        await DBOperation.getchecklistAllData(db);
    log("result22222:${result2.length} ==result3:::${result3.length}");
    String uuiDeviceId = uuid.v1();
    List<Map<String, Object?>> checkScanItem =
        await DBOperation.checkScandata(db, srialbtchx, itemcodex);

    List<Map<String, Object?>> checkpushedScanItem =
        await DBOperation.checkPushedAlreadyScandata(db, srialbtchx, itemcodex);

    List<Map<String, Object?>> checkErrorScanItem =
        await DBOperation.checkErrorAlreadyScandata(db, srialbtchx, itemcodex);
    log('checkpushedScanItemcheckpushedScanItemcheckpushedScanItem::${checkpushedScanItem.length}');
    if (scandata.isNotEmpty) {
      scandata[0].notes = mycontroller[6].text.toString();
      scandata[0].scanguid = uuiDeviceId;

      if (checkScanItem.isEmpty &&
          checkpushedScanItem.isEmpty &&
          checkErrorScanItem.isEmpty) {
        if (checklistdata.isNotEmpty) {
          for (var i = 0; i < checklistdata.length; i++) {
            checklistdata[i].scanguid = uuiDeviceId;
          }
          await DBOperation.insertchecklistData(db, checklistdata)
              .then((value) {
            checklistdata = [];
          });

          notifyListeners();
        }
        await DBOperation.insertscanpostData(db, scandata).then((value) {
          focus2.requestFocus();
          nextdisable = false;
          totalscandeviceQty = 0;
          mycontroller[3].text = '';
          binTableDetails(mycontroller[2].text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Scanned data inserted successfully..!'),
              backgroundColor: Colors.green,
              elevation: 10,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(5),
              dismissDirection: DismissDirection.up,
            ),
          );
          notifyListeners();
        });
        notifyListeners();

        scandata = [];
        nextdisable = false;
        mycontroller[3].text = '';
        mycontroller[4].text = '';
        mycontroller[5].text = '';
        mycontroller[6].text = '';
        groupValueSelected = 0;
        skuCosde = '';
        itemCode = '';
        scanTime = '';
        itemName = '';
        serialBatch = '';
        dispAllvalList = [];
        isManualtype = false;
        selectFirstTapVal();
        notifyListeners();
      } else {
        scandata = [];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('This item already inserted..!!'),
            backgroundColor: Colors.red,
            elevation: 10,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(5),
            dismissDirection: DismissDirection.up,
          ),
        );
        nextdisable = false;
        notifyListeners();
      }
      notifyListeners();
    } else {
      nextdisable = false;
    }
    notifyListeners();
    scantotaldeviceqty();
  }

  callBinBlockApi(
      BuildContext context, ThemeData theme, String binpostdata) async {
    errorMsg = '';
    String? deviceId = await HelperFunctions.getDeviceIDSharedPreference();
    BinPostData? binpostDat = BinPostData();
    binpostDat = BinPostData(
        auditid: fetchAuditForDetails.docEntry,
        bincode: binpostdata,
        devicecode: deviceId,
        scantime: config.firstDate());
    await BinLockedAPi.getData(binpostDat).then((value) async {
      // log('messagessss');
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        isClickedStart = false;
        // log('respDescrespDesc::${value.respDesc}');
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        errorMsg = value.exception;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  List<GetDisPositonList> dispositionDataList = [];

  bool syncdatafreeze = false;
  checkNeworkConnectivity(BuildContext context, ThemeData theme) async {
    bool? noNetbool = await config.haveNoInterNet();
    if (noNetbool == false) {
      whileOffline = false;
      await Get.defaultDialog(
          barrierDismissible: false,
          title: 'Message',
          content: Column(
            children: [
              Text('Sync operation initiating.\nPlease wait for Sometime.'),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      foregroundColor: Colors.white,
                      backgroundColor: theme.primaryColor),
                  onPressed: () async {
                    syncdatafreeze = true;
                    Get.back();
                    await syncAllData(theme);
                  },
                  child: const Text(' Ok '))
            ],
          ));

      notifyListeners();
    } else {
      whileOffline = true;
      await Get.defaultDialog(
          title: 'Message',
          content: Column(
            children: [
              Text('Check Your Internet..!!'),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      foregroundColor: Colors.white,
                      backgroundColor: theme.primaryColor),
                  onPressed: () async {
                    log('ConstantValues.token222::${ConstantValues.token}');
                    Get.back();
                  },
                  child: const Text(' Ok '))
            ],
          ));

      notifyListeners();
    }
    notifyListeners();
  }

  saveAllExcel(BuildContext context, ThemeData theme) {
    pushedexcelvaluers = [];
    pendingexcelvaluers = [];
    errorexcelvaluers = [];
    createExcelForPending(context, theme);
    createExcelForPushed(context, theme);
    createExcelForerror(context, theme);
    if (pushedexcelvaluers.isNotEmpty ||
        pendingexcelvaluers.isNotEmpty ||
        errorexcelvaluers.isNotEmpty) {
      Get.dialog(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: Screens.width(context) * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Material(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Text("Successfull Saved..",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Colors.green,
                            )),
                        // const SizedBox(height: 15),
                        Text(
                          "Path Name:$path",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        //Buttons
                        SizedBox(
                          height: Screens.bodyheight(context) * 0.05,
                          width: Screens.width(context) * 0.3,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                              minimumSize: const Size(0, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text(
                              'Close',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }

  Future<void> createExcelForPushed(
      BuildContext context, ThemeData theme) async {
    final Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> pushedScannedPostData =
        await DBOperation.getpushedscandataData(
      db,
    );
    for (var i = 0; i < pushedScannedPostData.length; i++) {
      pushedexcelvaluers.add(ScanDataPost(
          auditid: int.parse(pushedScannedPostData[i]['Auditid'].toString()),
          bincode: pushedScannedPostData[i]['Bincode'].toString(),
          scanguid: pushedScannedPostData[i]['scanguid'].toString(),
          devicecode: pushedScannedPostData[i]['Devicecode'].toString(),
          checklist: [],
          ismanual: int.parse(pushedScannedPostData[i]['IsManual'].toString()),
          // errormsg: pushedScannedPostData[i]['ApiErrorMsg'].toString(),
          itemCode: pushedScannedPostData[i]['ItemCode'].toString(),
          notes: pushedScannedPostData[i]['Notes'].toString(),
          quantity:
              double.parse(pushedScannedPostData[i]['Quantity'].toString()),
          scandatetime: pushedScannedPostData[i]['Scandatetime'].toString(),
          serialbatch: pushedScannedPostData[i]['Serialbatch'].toString(),
          stockstatus: pushedScannedPostData[i]['Stockstatus'].toString(),
          templateid: pushedScannedPostData[i]['Templateid'] != null
              ? int.parse(pushedScannedPostData[i]['Templateid'].toString())
              : 0,
          whscode: pushedScannedPostData[i]['Whscode'].toString()));
    }
    // List<AssemblyModel> values = await DBOperation.getpushedscandataData(db)
    final xcel.Workbook workbook = xcel.Workbook();
    final xcel.Worksheet sheet = workbook.worksheets[0];
    // final xcel.Worksheet sheet2 = workbook.worksheets[1];

    // sheet.getRangeByName('A1').setText('Hello World!');
    sheet.getRangeByIndex(1, 1).setText("Auditid");
    sheet.getRangeByIndex(1, 2).setText("Bincode");
    sheet.getRangeByIndex(1, 3).setText("scanguid");
    sheet.getRangeByIndex(1, 4).setText("Devicecode");
    sheet.getRangeByIndex(1, 5).setText("IsManual");
    sheet.getRangeByIndex(1, 6).setText("ItemCode");
    sheet.getRangeByIndex(1, 7).setText("Notes");
    sheet.getRangeByIndex(1, 8).setText("Quantity");
    sheet.getRangeByIndex(1, 9).setText("Scandatetime");
    sheet.getRangeByIndex(1, 10).setText("Serialbatch");
    sheet.getRangeByIndex(1, 11).setText("Stockstatus");
    sheet.getRangeByIndex(1, 12).setText("Templateid");
    sheet.getRangeByIndex(1, 13).setText("Whscode");

    for (var i = 0; i < pushedexcelvaluers.length; i++) {
      final item = pushedexcelvaluers[i];
      sheet.getRangeByIndex(i + 2, 1).setText(item.auditid.toString());
      sheet.getRangeByIndex(i + 2, 2).setText(item.bincode.toString());
      sheet.getRangeByIndex(i + 2, 3).setText(item.scanguid.toString());
      sheet.getRangeByIndex(i + 2, 4).setText(item.devicecode.toString());

      sheet.getRangeByIndex(i + 2, 5).setText(item.ismanual.toString());
      sheet.getRangeByIndex(i + 2, 6).setText(item.itemCode.toString());
      sheet.getRangeByIndex(i + 2, 7).setText(item.notes.toString());
      sheet.getRangeByIndex(i + 2, 8).setText(item.quantity.toString());

      sheet.getRangeByIndex(i + 2, 9).setText(item.scandatetime.toString());
      sheet.getRangeByIndex(i + 2, 10).setText(item.serialbatch.toString());
      sheet.getRangeByIndex(i + 2, 11).setText(item.stockstatus.toString());
      sheet.getRangeByIndex(i + 2, 12).setText(item.templateid.toString());
      sheet.getRangeByIndex(i + 2, 13).setText(item.whscode.toString());
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    path = await getExternalDocumentPath();
    var id = DateTime.now().millisecondsSinceEpoch;
    log('pathpathpathexcel11:::$path');
    // final String path = (await getApplicationSupportDirectory()).path;

    final String fileName =
        Platform.isIOS ? '$path\/pusheddata.xlsx' : '$path/$id-pusheddata.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> createExcelForerror(
      BuildContext context, ThemeData theme) async {
    final Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> ErrorsScasnnedData =
        await DBOperation.getErrorscandataData(
      db,
    );

    if (ErrorsScasnnedData.isNotEmpty) {
      errorexcelvaluers = [];

      for (var i = 0; i < ErrorsScasnnedData.length; i++) {
        errorexcelvaluers.add(ErrorScanDataPost(
            auditid: int.parse(ErrorsScasnnedData[i]['Auditid'].toString()),
            bincode: ErrorsScasnnedData[i]['Bincode'].toString(),
            scanguid: ErrorsScasnnedData[i]['scanguid'].toString(),
            devicecode: ErrorsScasnnedData[i]['Devicecode'].toString(),
            checklist: [],
            ismanual: int.parse(ErrorsScasnnedData[i]['IsManual'].toString()),
            // errormsg: pushedScannedPostData[i]['ApiErrorMsg'].toString(),
            itemCode: ErrorsScasnnedData[i]['ItemCode'].toString(),
            notes: ErrorsScasnnedData[i]['Notes'].toString(),
            quantity:
                double.parse(ErrorsScasnnedData[i]['Quantity'].toString()),
            scandatetime: ErrorsScasnnedData[i]['Scandatetime'].toString(),
            serialbatch: ErrorsScasnnedData[i]['Serialbatch'].toString(),
            stockstatus: ErrorsScasnnedData[i]['Stockstatus'].toString(),
            templateid: ErrorsScasnnedData[i]['Templateid'] != null
                ? int.parse(ErrorsScasnnedData[i]['Templateid'].toString())
                : 0,
            whscode: ErrorsScasnnedData[i]['Whscode'].toString(),
            errormsg: ErrorsScasnnedData[i]['ApiErrorMsg'].toString()));
      }
      // List<AssemblyModel> values = await DBOperation.getpushedscandataData(db)
      final xcel.Workbook workbook = xcel.Workbook();
      final xcel.Worksheet sheet = workbook.worksheets[0];
      // final xcel.Worksheet sheet2 = workbook.worksheets[1];

      // sheet.getRangeByName('A1').setText('Hello World!');
      sheet.getRangeByIndex(1, 1).setText("Auditid");
      sheet.getRangeByIndex(1, 2).setText("Bincode");
      sheet.getRangeByIndex(1, 3).setText("scanguid");
      sheet.getRangeByIndex(1, 4).setText("Devicecode");
      sheet.getRangeByIndex(1, 5).setText("IsManual");
      sheet.getRangeByIndex(1, 6).setText("ItemCode");
      sheet.getRangeByIndex(1, 7).setText("Notes");
      sheet.getRangeByIndex(1, 8).setText("Quantity");
      sheet.getRangeByIndex(1, 9).setText("Scandatetime");
      sheet.getRangeByIndex(1, 10).setText("Serialbatch");
      sheet.getRangeByIndex(1, 11).setText("Stockstatus");
      sheet.getRangeByIndex(1, 12).setText("Templateid");
      sheet.getRangeByIndex(1, 13).setText("Whscode");
      sheet.getRangeByIndex(1, 13).setText("ApiErrorMsg");

      for (var i = 0; i < errorexcelvaluers.length; i++) {
        final item = errorexcelvaluers[i];
        sheet.getRangeByIndex(i + 2, 1).setText(item.auditid.toString());
        sheet.getRangeByIndex(i + 2, 2).setText(item.bincode.toString());
        sheet.getRangeByIndex(i + 2, 3).setText(item.scanguid.toString());
        sheet.getRangeByIndex(i + 2, 4).setText(item.devicecode.toString());

        sheet.getRangeByIndex(i + 2, 5).setText(item.ismanual.toString());
        sheet.getRangeByIndex(i + 2, 6).setText(item.itemCode.toString());
        sheet.getRangeByIndex(i + 2, 7).setText(item.notes.toString());
        sheet.getRangeByIndex(i + 2, 8).setText(item.quantity.toString());

        sheet.getRangeByIndex(i + 2, 9).setText(item.scandatetime.toString());
        sheet.getRangeByIndex(i + 2, 10).setText(item.serialbatch.toString());
        sheet.getRangeByIndex(i + 2, 11).setText(item.stockstatus.toString());
        sheet.getRangeByIndex(i + 2, 12).setText(item.templateid.toString());
        sheet.getRangeByIndex(i + 2, 13).setText(item.whscode.toString());
        sheet.getRangeByIndex(i + 2, 13).setText(item.errormsg.toString());
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      path = await getExternalDocumentPath();
      var id = DateTime.now().millisecondsSinceEpoch;
      log('pathpathpathexcel22:::$path');
      // final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isIOS ? '$path\/errordata.xlsx' : '$path/$id-errordata.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
    }
  }

  Future<void> createExcelForPending(
      BuildContext context, ThemeData theme) async {
    final Database db = (await DBHelper.getInstance())!;
    List<Map<String, Object?>> getcasnnedData =
        await DBOperation.getscandataData(
      db,
    );

    if (getcasnnedData.isNotEmpty) {
      pendingexcelvaluers = [];

      for (var i = 0; i < getcasnnedData.length; i++) {
        pendingexcelvaluers.add(ScanDataPost(
          auditid: int.parse(getcasnnedData[i]['Auditid'].toString()),
          bincode: getcasnnedData[i]['Bincode'].toString(),
          scanguid: getcasnnedData[i]['scanguid'].toString(),
          devicecode: getcasnnedData[i]['Devicecode'].toString(),
          checklist: [],
          ismanual: int.parse(getcasnnedData[i]['IsManual'].toString()),
          // errormsg: pushedScannedPostData[i]['ApiErrorMsg'].toString(),
          itemCode: getcasnnedData[i]['ItemCode'].toString(),
          notes: getcasnnedData[i]['Notes'].toString(),
          quantity: double.parse(getcasnnedData[i]['Quantity'].toString()),
          scandatetime: getcasnnedData[i]['Scandatetime'].toString(),
          serialbatch: getcasnnedData[i]['Serialbatch'].toString(),
          stockstatus: getcasnnedData[i]['Stockstatus'].toString(),
          templateid: getcasnnedData[i]['Templateid'] != null
              ? int.parse(getcasnnedData[i]['Templateid'].toString())
              : 0,
          whscode: getcasnnedData[i]['Whscode'].toString(),
        ));
      }
      // List<AssemblyModel> values = await DBOperation.getpushedscandataData(db)
      final xcel.Workbook workbook = xcel.Workbook();
      final xcel.Worksheet sheet = workbook.worksheets[0];
      // final xcel.Worksheet sheet2 = workbook.worksheets[1];

      // sheet.getRangeByName('A1').setText('Hello World!');
      sheet.getRangeByIndex(1, 1).setText("Auditid");
      sheet.getRangeByIndex(1, 2).setText("Bincode");
      sheet.getRangeByIndex(1, 3).setText("scanguid");
      sheet.getRangeByIndex(1, 4).setText("Devicecode");
      sheet.getRangeByIndex(1, 5).setText("IsManual");
      sheet.getRangeByIndex(1, 6).setText("ItemCode");
      sheet.getRangeByIndex(1, 7).setText("Notes");
      sheet.getRangeByIndex(1, 8).setText("Quantity");
      sheet.getRangeByIndex(1, 9).setText("Scandatetime");
      sheet.getRangeByIndex(1, 10).setText("Serialbatch");
      sheet.getRangeByIndex(1, 11).setText("Stockstatus");
      sheet.getRangeByIndex(1, 12).setText("Templateid");
      sheet.getRangeByIndex(1, 13).setText("Whscode");

      for (var i = 0; i < pendingexcelvaluers.length; i++) {
        final item = pendingexcelvaluers[i];
        sheet.getRangeByIndex(i + 2, 1).setText(item.auditid.toString());
        sheet.getRangeByIndex(i + 2, 2).setText(item.bincode.toString());
        sheet.getRangeByIndex(i + 2, 3).setText(item.scanguid.toString());
        sheet.getRangeByIndex(i + 2, 4).setText(item.devicecode.toString());

        sheet.getRangeByIndex(i + 2, 5).setText(item.ismanual.toString());
        sheet.getRangeByIndex(i + 2, 6).setText(item.itemCode.toString());
        sheet.getRangeByIndex(i + 2, 7).setText(item.notes.toString());
        sheet.getRangeByIndex(i + 2, 8).setText(item.quantity.toString());

        sheet.getRangeByIndex(i + 2, 9).setText(item.scandatetime.toString());
        sheet.getRangeByIndex(i + 2, 10).setText(item.serialbatch.toString());
        sheet.getRangeByIndex(i + 2, 11).setText(item.stockstatus.toString());
        sheet.getRangeByIndex(i + 2, 12).setText(item.templateid.toString());
        sheet.getRangeByIndex(i + 2, 13).setText(item.whscode.toString());
      }

      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      path = await getExternalDocumentPath();
      var id = DateTime.now().millisecondsSinceEpoch;
      log('pathpathpathexcel33:::$path');
      // final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = Platform.isIOS
          ? '$path\/pendingdata.xlsx'
          : '$path/$id-pendingdata.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
    }
  }

  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
    }
    Directory directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      directory = (await getExternalStorageDirectory())!;
    } else {
      directory = await getApplicationSupportDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);

    return exPath;
  }

  syncAllData(ThemeData theme) async {
    Database db = (await DBHelper.getInstance())!;
    auditScannData = [];
    errorMsg = '';
    List<ScanDataPost> scandatax = [];
    List<ErrorScanDataPost> errorscandatax = [];
    List<DispListData> checklistt = [];
    List<Map<String, Object?>> result2 = await DBOperation.getscandataData(db);
    if (result2.isNotEmpty) {
      scandatax = [];
      log('result2result2scandata::${result2.length}');

      for (var i = 0; i < result2.length; i++) {
        checklistt = [];

        List<Map<String, Object?>> checlistresult2 =
            await DBOperation.getchecklistData(
                db, result2[i]['scanguid'].toString());
        if (checlistresult2.isNotEmpty) {
          for (var i = 0; i < checlistresult2.length; i++) {
            checklistt.add(DispListData(
                attachurl: checlistresult2[i]['Attachurl'].toString(),
                auditid: int.parse(checlistresult2[i]['Auditid'].toString()),
                checklistcode: checlistresult2[i]['Checklistcode'].toString(),
                checklistvalue:
                    checlistresult2[i]['Checklistvalue'].toString()));
          }
        }
        log('checklisttchecklistt::${checklistt.length}');
        scandatax.add(ScanDataPost(
            auditid: int.parse(result2[i]['Auditid'].toString()),
            bincode: result2[i]['Bincode'].toString() ?? '',
            devicecode: result2[i]['Devicecode'].toString() ?? '',
            ismanual: 0,
            // int.parse(result2[i]['IsManual'].toString()),
            itemCode: result2[i]['ItemCode'].toString() ?? '',
            notes: result2[i]['Notes'].toString() ?? '',
            quantity: double.parse(result2[i]['Quantity'].toString()),
            scandatetime: result2[i]['Scandatetime'].toString() ?? '',
            serialbatch: result2[i]['Serialbatch'].toString() ?? '',
            stockstatus: result2[i]['Stockstatus'].toString() ?? '',
            templateid: result2[i]['Templateid'] != null
                ? int.parse(result2[i]['Templateid'].toString())
                : 0,
            scanguid: result2[i]['scanguid'].toString() ?? '',
            whscode: result2[i]['Whscode'].toString() ?? '',
            checklist: checklistt));
      }

      notifyListeners();
      log('scandataxscandatax::${scandatax.length}');

      for (int ij = 0; ij < scandatax.length; ij++) {
        log('scandataxscandatax222::${scandatax[ij].auditid}}');
        ScannLockedAPiApi.apiJsonMethod(scandatax[ij]);

        await ScannLockedAPiApi.getData(scandatax[ij]).then((value) async {
          if (value.stsCode >= 200 && value.stsCode <= 210) {
            if (value.respCode == "WS100") {
              auditScannData = value.scannData;
              List<ScanDataPost> insertdata = [];
              insertdata.add(ScanDataPost(
                  auditid: scandatax[ij].auditid,
                  bincode: scandatax[ij].bincode,
                  scanguid: scandatax[ij].scanguid,
                  devicecode: scandatax[ij].devicecode,
                  ismanual: scandatax[ij].ismanual,
                  itemCode: scandatax[ij].itemCode,
                  notes: scandatax[ij].notes,
                  quantity: scandatax[ij].quantity,
                  scandatetime: scandatax[ij].scandatetime,
                  serialbatch: scandatax[ij].serialbatch,
                  stockstatus: scandatax[ij].stockstatus,
                  checklist: scandatax[ij].checklist,
                  templateid: scandatax[ij].templateid,
                  whscode: scandatax[ij].whscode));
              await DBOperation.insertPushedscanpostData(db, insertdata)
                  .then((value) async {
                await DBOperation.getpushedscandataData(db);
                await DBOperation.getDeleteScanlistData(
                  db,
                  scandatax[ij].scanguid.toString(),
                ).then(
                  (value) {
                    // scandatax.removeAt(i);
                    log("afterdeletescan1111::;" + scandatax.length.toString());
                  },
                );
                totalscandeviceQty = 0;
              });

              log('getAuditList::${auditScannData.length}');
              notifyListeners();
            } else {
              log(' value.respDesc value.respDesc::${value.respDesc}');
              errorscandatax = [];
              errorscandatax.add(ErrorScanDataPost(
                  auditid: scandatax[ij].auditid,
                  bincode: scandatax[ij].bincode,
                  scanguid: scandatax[ij].scanguid,
                  devicecode: scandatax[ij].devicecode,
                  ismanual: scandatax[ij].ismanual,
                  errormsg: value.respDesc,
                  itemCode: scandatax[ij].itemCode,
                  notes: scandatax[ij].notes,
                  quantity: scandatax[ij].quantity,
                  scandatetime: scandatax[ij].scandatetime,
                  serialbatch: scandatax[ij].serialbatch,
                  stockstatus: scandatax[ij].stockstatus,
                  checklist: scandatax[ij].checklist,
                  templateid: scandatax[ij].templateid,
                  whscode: scandatax[ij].whscode));

              notifyListeners();

              await DBOperation.insertErrorscanpostData(db, errorscandatax)
                  .then((value) async {
                totalscandeviceQty = 0;
                await getScannedInformation(
                    int.parse(fetchAuditForDetails.docEntry.toString()));
                viewmain = false;
                viewerrors = true;
                viewsucess = false;
                await DBOperation.getDeleteScanlistData(
                  db,
                  scandatax[ij].scanguid.toString(),
                ).then((value) {
                  log("afterdeletescan2222::;" + scandatax.length.toString());
                });

                await DBOperation.getErrorscandataData(db);

                notifyListeners();
              });
            }
          } else {
            errorscandatax = [];
            errorscandatax.add(ErrorScanDataPost(
                auditid: scandatax[ij].auditid,
                bincode: scandatax[ij].bincode,
                scanguid: scandatax[ij].scanguid,
                devicecode: scandatax[ij].devicecode,
                ismanual: scandatax[ij].ismanual,
                errormsg: value.respDesc,
                itemCode: scandatax[ij].itemCode,
                notes: scandatax[ij].notes,
                quantity: scandatax[ij].quantity,
                scandatetime: scandatax[ij].scandatetime,
                serialbatch: scandatax[ij].serialbatch,
                stockstatus: scandatax[ij].stockstatus,
                checklist: scandatax[ij].checklist,
                templateid: scandatax[ij].templateid,
                whscode: scandatax[ij].whscode));

            notifyListeners();
            errorMsg = value.exception;
            isLoading = false;
            await DBOperation.insertErrorscanpostData(db, errorscandatax)
                .then((value) async {
              totalscandeviceQty = 0;
              await getScannedInformation(
                  int.parse(fetchAuditForDetails.docEntry.toString()));
              viewmain = false;
              viewerrors = true;
              viewsucess = false;
              await DBOperation.getDeleteScanlistData(
                db,
                scandatax[ij].scanguid.toString(),
              ).then((value) async {
                log("afterdeletescan3333::;" + scandatax.length.toString());
              });
              await DBOperation.getErrorscandataData(db);
              notifyListeners();
            });
          }
        });
        notifyListeners();
      }

      log('Successsssss1111');
    }
    await resyncMethod(theme);
    await selectFirstTapVal();

    notifyListeners();
  }

  callGetuserDetailsnApi(
    int docEntry,
    BuildContext context,
    ThemeData theme,
  ) async {
    usetDetailData = [];
    errorMsg = '';
    isLoading = true;
    await GetuserDetailsApi.getData(docEntry).then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        usetDetailData = value.userData;
        isLoading = false;
        log('UsetDetailData::${usetDetailData.length}');
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        errorMsg = value.exception;
        apiResponseDialog(context, theme, errorMsg);
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
      }
    });
    notifyListeners();
  }

  addscanneddata(int i) async {
    String? deviceID = await HelperFunctions.getDeviceIDSharedPreference();
    scandata = [];
    // String uuiDeviceId = uuid.v1();
    // log('isSelectedCusTagxxx::${fetchAuditForDetails.docEntry.toString()}');
    // log('mycontroller[6].textsssssss::${uuiDeviceId}');

    scandata.add(ScanDataPost(
        auditid: fetchAuditForDetails.docEntry,
        bincode: mycontroller[2].text,
        devicecode: deviceID,
        ismanual: isManualtype == true ? 1 : 0,
        itemCode: mycontroller[4].text,
        notes: mycontroller[6].text,
        quantity: double.parse(mycontroller[5].text),
        scandatetime: config.firstDate(),
        serialbatch: mycontroller[3].text,
        stockstatus: isSelectedCusTag,
        scanguid: '',
        templateid: dispCode,
        whscode: fetchAuditForDetails.whsCode,
        checklist: checklistdata));

    log('scandatascandata length3333::${scandata.length}');
    notifyListeners();
  }

  serialNumberItemQty(BuildContext context, ThemeData theme, int i) {
    int qtyval = 0;
    if (mycontroller[5].text.isEmpty) {
      mycontroller[5].text = 1.toString();
      // addscanneddata(i);
      log('scandatascandata length222::${scandata.length}');
      notifyListeners();
    } else {
      qtyval = int.parse(mycontroller[5].text);
      log('mycontroller[5].text:${mycontroller[5].text}:::qtyval::$qtyval');
      qtyval = qtyval + int.parse(mycontroller[5].text);
      mycontroller[5].text = qtyval.toString();
      if (qtyval < 1) {
        mycontroller[5].text = 1.toString();
      } else if (qtyval > 1) {
        mycontroller[5].text = 1.toString();
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Container(
                        // width: Screens.width(context) * 0.75,
                        child: Center(
                            child: Text("Alert",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'You are not permit the scanning this item. However, Already scanned this itemcode',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      width: Screens.width(context) * 0.9,
                      height: Screens.bodyheight(context) * 0.06,
                      child: ElevatedButton(
                          onPressed: () async {
                            // context
                            //     .read<AuditCtrlProvider>()
                            //     .apiResponseDialog(context, theme, 'Success');
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                          ),
                          child: const Text("OK")),
                    ),
                  ],
                ),
              );
            });
        notifyListeners();
      }
      notifyListeners();
    }
  }

  // batchIncreaseQty(List<LineData> lineItemResult, int i) {
  //   if (mycontroller[5].text.isNotEmpty) {
  //     incQty = int.parse(mycontroller[5].text);
  //     mycontroller[5].text = (incQty + 1).toString();

  //     for (var ix = 0; ix < scandata.length; ix++) {
  //       if (scandata[ix].serialbatch == mycontroller[3].text &&
  //           scandata[ix].itemCode == mycontroller[4].text) {
  //         scandata[ix].quantity = double.parse(mycontroller[5].text);
  //         log('scandata[ix].quantity scandata[ix].quantity::${scandata[ix].quantity}');
  //       }
  //     }
  //     notifyListeners();
  //   } else {
  //     mycontroller[5].text = 1.toString();
  //     notifyListeners();
  //     addscanneddata(i);
  //   }
  //   // for (var i = 0; i < lineItemResult.length; i++) {

  //   // }
  //   // }
  //   log('mycontroller[4]::${mycontroller[4].text}');
  // }
  callGetBinNumApiApi(
    int docEntry,
    BuildContext context,
    ThemeData theme,
  ) async {
    getBinList = [];
    errorMsg = '';
    isLoading = true;
    await GetBinNumApi.getData(docEntry).then((value) async {
      if (value.stsCode >= 200 && value.stsCode <= 210) {
        getBinList = value.binData;
        isLoading = false;
        mycontroller[2].text = getBinList[0].binCode ?? '';

        binTableDetails(mycontroller[2].text);
        log('getBinList::${getBinList.length}');
        notifyListeners();
      } else if (value.stsCode >= 400 && value.stsCode <= 410) {
        errorMsg = value.exception;
        // apiResponseDialog(context, theme, errorMsg);

        isLoading = false;
        notifyListeners();
      }
    });
    checkCtrlFocus();

    notifyListeners();
  }

  splitAuditJob() {
    log('getAuditListgetAuditList::${getAuditList.length}');
    errorMsg = '';
    if (getAuditList.isNotEmpty) {
      for (var i = 0; i < getAuditList.length; i++) {
        // log("getAuditList[i].status::${getAuditList[i].status}");
        if (getAuditList[i].status == 'Open' ||
            getAuditList[i].status == 'Starting' ||
            getAuditList[i].status == 'In-Process') {
          openAuditList.add(GetAuditDataModel(
              auditFrom: getAuditList[i].auditFrom ?? '',
              auditTo: getAuditList[i].auditTo,
              blockTrans: getAuditList[i].blockTrans,
              createdBy: getAuditList[i].createdBy,
              createdDatetime: getAuditList[i].createdDatetime,
              docDate: getAuditList[i].docDate,
              deviceCode: getAuditList[i].deviceCode,
              isStarting: false,
              percent: getAuditList[i].percent,
              docEntry: getAuditList[i].docEntry,
              docNum: getAuditList[i].docNum,
              endDate: getAuditList[i].endDate,
              remarks: getAuditList[i].remarks,
              repeat: getAuditList[i].repeat,
              repeatDay: getAuditList[i].repeatDay,
              repeatFrequency: getAuditList[i].repeatFrequency,
              scheduleName: getAuditList[i].scheduleName,
              startDate: getAuditList[i].startDate,
              status: getAuditList[i].status,
              traceid: getAuditList[i].traceid,
              updatedBy: getAuditList[i].updatedBy,
              user: getAuditList[i].user,
              updatedDatetime: getAuditList[i].updatedDatetime,
              whsCode: getAuditList[i].whsCode,
              unitsScanned: getAuditList[i].unitsScanned,
              totalItems: getAuditList[i].totalItems));
        } else if (getAuditList[i].status == 'Completed' ||
            getAuditList[i].status == 'Closed') {
          NoDataMsg = '';
          completedAuditList.add(GetAuditDataModel(
              auditFrom: getAuditList[i].auditFrom,
              percent: getAuditList[i].percent,
              deviceCode: getAuditList[i].deviceCode,
              auditTo: getAuditList[i].auditTo,
              blockTrans: getAuditList[i].blockTrans,
              unitsScanned: getAuditList[i].unitsScanned,
              totalItems: getAuditList[i].totalItems,
              createdBy: getAuditList[i].createdBy,
              createdDatetime: getAuditList[i].createdDatetime,
              isStarting: false,
              docDate: getAuditList[i].docDate,
              user: getAuditList[i].user,
              docEntry: getAuditList[i].docEntry,
              docNum: getAuditList[i].docNum,
              endDate: getAuditList[i].endDate,
              remarks: getAuditList[i].remarks,
              repeat: getAuditList[i].repeat,
              repeatDay: getAuditList[i].repeatDay,
              repeatFrequency: getAuditList[i].repeatFrequency,
              scheduleName: getAuditList[i].scheduleName,
              startDate: getAuditList[i].startDate,
              status: getAuditList[i].status,
              traceid: getAuditList[i].traceid,
              updatedBy: getAuditList[i].updatedBy,
              updatedDatetime: getAuditList[i].updatedDatetime,
              whsCode: getAuditList[i].whsCode));
        } else if (getAuditList[i].status == 'Upcoming' ||
            getAuditList[i].status == 'Draft') {
          NoDataMsg = '';

          upcomingtAuditList.add(GetAuditDataModel(
              auditFrom: getAuditList[i].auditFrom,
              auditTo: getAuditList[i].auditTo,
              unitsScanned: getAuditList[i].unitsScanned,
              percent: getAuditList[i].percent,
              totalItems: getAuditList[i].totalItems,
              deviceCode: getAuditList[i].deviceCode,
              user: getAuditList[i].user,
              blockTrans: getAuditList[i].blockTrans,
              isStarting: false,
              createdBy: getAuditList[i].createdBy,
              createdDatetime: getAuditList[i].createdDatetime,
              docDate: getAuditList[i].docDate,
              docEntry: getAuditList[i].docEntry,
              docNum: getAuditList[i].docNum,
              endDate: getAuditList[i].endDate,
              remarks: getAuditList[i].remarks,
              repeat: getAuditList[i].repeat,
              repeatDay: getAuditList[i].repeatDay,
              repeatFrequency: getAuditList[i].repeatFrequency,
              scheduleName: getAuditList[i].scheduleName,
              startDate: getAuditList[i].startDate,
              status: getAuditList[i].status,
              traceid: getAuditList[i].traceid,
              updatedBy: getAuditList[i].updatedBy,
              updatedDatetime: getAuditList[i].updatedDatetime,
              whsCode: getAuditList[i].whsCode));
        }
      }
    }
  }

  // auditDataMethod() {
  //   auditList = [];
  //   auditList = [
  //     AuditModelList(
  //         auditby: 'Mr.Ravish',
  //         description: 'Monthly AC Stock Audit',
  //         location: 'Main Warehouse',
  //         percentage: '23%',
  //         scheduleDate: '21-06-2024',
  //         status: 'Completed',
  //         unit: '2304 Units'),
  //     AuditModelList(
  //         auditby: 'Mr. Ravish',
  //         description: 'Daily Mobile Stock Audit',
  //         location: 'Main Warehouse',
  //         percentage: '',
  //         scheduleDate: '26-05-2024',
  //         status: 'Not Started',
  //         unit: '1550 Units'),
  //     AuditModelList(
  //         auditby: 'Mr.Kevin',
  //         description: 'Weekly HA Items Audit',
  //         location: 'TNV1 Stroe',
  //         percentage: '',
  //         scheduleDate: '21-04-2024',
  //         status: 'Re-Audit',
  //         unit: '2304 Units')
  //   ];
  //   notifyListeners();
  // }

  String validteText = '';
  String apiResponse = '';
  validateReschedule(
      BuildContext context, ThemeData theme, int docentry) async {
    apiResponse = '';
    if (formkey[0].currentState!.validate()) {
      DateTime date = DateTime.now();
      String chooseddate;
      chooseddate =
          "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
      log('${chooseddate.toString()} == ${mycontroller[0].text}');
      if (chooseddate == mycontroller[0].text) {
        validteText = 'Please enter future date';
        notifyListeners();
      } else {
        validteText = '';
        await GetAuditRescheduleApi.getData(docentry, apidate)
            .then((value) async {
          if (value.stsCode >= 200 && value.stsCode <= 210) {
            apiResponse = value.respDesc;
            isLoading = false;
            Get.back();
            apiResponseDialog(context, theme, apiResponse);
            log('getBinList::${getBinList.length}');
            notifyListeners();
          } else if (value.stsCode >= 400 && value.stsCode <= 410) {
            errorMsg = value.exception;
            Get.back();
            apiResponseDialog(context, theme, errorMsg);
            isLoading = false;
            notifyListeners();
          }
        });
        notifyListeners();
      }
      notifyListeners();
    }
  }

  checktimediv(BuildContext context, ThemeData theme, String apiRes,
      String actionName, int docEntry, int indx) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Screens.width(context) * 0.8,
                            child: Center(
                                child: Text("Message",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(apiRes),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          bottom: Screens.padingHeight(context) * 0.02),
                      // width: Screens.width(context) * 0.,
                      // height: Screens.bodyheight(context) * 0.05,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            // primary: theme.primaryColor,
                            textStyle: const TextStyle(color: Colors.white),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )),
                          ),
                          onPressed: () async {
                            Get.back();
                            String mssgg =
                                "Already this audit related data are available in memory. Click 'Continue' to proceed with this data or 'Reset' to start a new process.";

                            checkTableEmpty(
                              context,
                              theme,
                              mssgg,
                              actionName,
                              docEntry,
                              indx,
                            );
                            notifyListeners();
                          },
                          child: const Text(
                            " OK ",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ])),
            );
          });
        });
    notifyListeners();
  }

//
  actionResetDialog(BuildContext context, ThemeData theme, String apiRes,
      String actionName, int docEntry, int indx) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: Screens.width(context) * 0.8,
                            child: Center(
                                child: Text("Warning",
                                    style: theme.textTheme.bodyLarge!
                                        .copyWith(color: Colors.white))),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(apiRes),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Screens.width(context) * 0.445,
                          height: Screens.bodyheight(context) * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,

                                // primary: theme.primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(0),
                                )),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                "Continue",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          width: Screens.width(context) * 0.445,
                          height: Screens.bodyheight(context) * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,

                                // primary: theme.primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(8),
                                )),
                              ),
                              onPressed: () async {
                                final database =
                                    (await AppDatabase.initialize())!;
                                // await driftoperation.deleteBinListItemById(
                                //     docEntry, database);

                                // await driftoperation.deleteListItemById(
                                //     docEntry, database);
                                await driftoperation.deletItemCodeDataById(
                                    docEntry, database);
                                Get.back();
                                String mssgg2 =
                                    'This Operation may take few minutes. Closing the application may interrupt the process.\n Do you want to continue ?';
                                actionwarningDialog(context, theme, mssgg2,
                                    'Start', docEntry, indx);
                              },
                              child: const Text(
                                "Reset",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ])),
            );
          });
        });
  }

  resyncMethod(ThemeData theme) async {
    auditScannData = [];
    errorMsg = '';
    List<ScanDataPost> scandatax = [];
    List<DispListData> checklistt = [];
    Database db = (await DBHelper.getInstance())!;

    List<Map<String, Object?>> result2 =
        await DBOperation.getErrorscandataData(db);
    if (result2.isNotEmpty) {
      scandatax = [];
      log('result2result2scandata::${result2.length}');
      //   for (var ij = 0; ij < result3.length; ij++) {
      //     // if (int.parse(result2[i]['Auditid'].toString()) ==
      //     //     int.parse(result3[ij]['Auditid'].toString())) {
      //   checklistt.add(CheckList(
      //       attachurl: result3[ij]['Attachurl'].toString(),
      //       auditid: int.parse(result3[ij]['Auditid'].toString()),
      //       checklistcode: result3[ij]['Checklistcode'].toString(),
      //       checklistvalue: result3[ij]['Checklistvalue'].toString()));
      // }
      for (var i = 0; i < result2.length; i++) {
        checklistt = [];
        // List<Map<String, Object?>> result3 = await DBOperation.getchecklistData(
        //     db, int.parse(result2[i]['Auditid'].toString()));
        // for (var ij = 0; ij < result3.length; ij++) {
        //   checklistt.add(DispListData(
        //       attachurl: result3[ij]['Attachurl'].toString(),
        //       auditid: int.parse(result3[ij]['Auditid'].toString()),
        //       checklistcode: result3[ij]['Checklistcode'].toString(),
        //       checklistvalue: result3[ij]['Checklistvalue'].toString()));
        // }
        scandatax.add(ScanDataPost(
            // localid: int.parse(result2[i]['SId'].toString()),
            auditid: int.parse(result2[i]['Auditid'].toString()),
            bincode: result2[i]['Bincode'].toString(),
            devicecode: result2[i]['Devicecode'].toString(),
            ismanual: int.parse(result2[i]['IsManual'].toString()),
            itemCode: result2[i]['ItemCode'].toString(),
            notes: result2[i]['Notes'].toString(),
            quantity: double.parse(result2[i]['Quantity'].toString()),
            scandatetime: result2[i]['Scandatetime'].toString(),
            serialbatch: result2[i]['Serialbatch'].toString(),
            stockstatus: result2[i]['Stockstatus'].toString(),
            templateid: result2[i]['Templateid'] != null
                ? int.parse(result2[i]['Templateid'].toString())
                : 0,
            scanguid: result2[i]['scanguid'].toString(),
            whscode: result2[i]['Whscode'].toString(),
            checklist: checklistt));
        // }
        notifyListeners();
      }
      notifyListeners();

      for (var ij = 0; ij < scandatax.length; ij++) {
        ScannLockedAPiApi.apiJsonMethod(scandatax[ij]);
        await ScannLockedAPiApi.getData(scandatax[ij]).then((value) async {
          if (value.stsCode >= 200 && value.stsCode <= 210) {
            if (value.respCode == "WS100") {
              auditScannData = value.scannData;
              List<ScanDataPost> insertdata = [];
              insertdata.add(ScanDataPost(
                  auditid: scandatax[ij].auditid,
                  bincode: scandatax[ij].bincode,
                  scanguid: scandatax[ij].scanguid,
                  devicecode: scandatax[ij].devicecode,
                  ismanual: scandatax[ij].ismanual,
                  itemCode: scandatax[ij].itemCode,
                  notes: scandatax[ij].notes,
                  quantity: scandatax[ij].quantity,
                  scandatetime: scandatax[ij].scandatetime,
                  serialbatch: scandatax[ij].serialbatch,
                  stockstatus: scandatax[ij].stockstatus,
                  checklist: scandatax[ij].checklist,
                  templateid: scandatax[ij].templateid,
                  whscode: scandatax[ij].whscode));

              await DBOperation.insertPushedscanpostData(db, insertdata)
                  .then((values) async {
                await DBOperation.getpushedscandataData(db);
                await DBOperation.getDeleteerrorScanlistData(
                  db,
                  scandatax[ij].scanguid.toString(),
                );
                notifyListeners();
              });

              log('ErrorgetAuditList::${auditScannData.length}');
              notifyListeners();
            } else {
              await DBOperation.getErrorscandataData(db);
              notifyListeners();
            }
          } else {
            errorMsg = value.exception;
            isLoading = false;
            notifyListeners();
          }
        });
        notifyListeners();
      }
    }
    await Get.defaultDialog(
        title: 'Message',
        content: Column(
          children: [
            Text('Sync Operation Completed..!!'),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    foregroundColor: Colors.white,
                    backgroundColor: theme.primaryColor),
                onPressed: () async {
                  syncdatafreeze = false;
                  await getScannedInformation(
                      int.parse(fetchAuditForDetails.docEntry.toString()));
                  viewmain = false;
                  viewerrors = false;
                  viewsucess = true;
                  Get.back();
                  // context.read<DashBoardCtrlProvider>().selectedIndex =
                  //     1;
                  // Get.offAllNamed(ConstantRoutes.dashboard);
                },
                child: const Text(' Ok '))
          ],
        ));
  }

  actionwarningDialog(BuildContext context, ThemeData theme, String apiRes,
      String actionName, int docEntry, int indx) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Container(
                        width: Screens.width(context) * 0.8,
                        child: Center(
                            child: Text("Warning",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(apiRes),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Screens.width(context) * 0.445,
                          height: Screens.bodyheight(context) * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,

                                // primary: theme.primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(0),
                                )),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(
                          width: Screens.width(context) * 0.445,
                          height: Screens.bodyheight(context) * 0.06,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,

                                // primary: theme.primaryColor,
                                textStyle: const TextStyle(color: Colors.white),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(8),
                                )),
                              ),
                              onPressed: () {
                                freezeItemCode = false;
                                Get.back();
                                openAuditList[indx].isStarting = true;
                                callGetItemCodeApi(
                                    context, theme, docEntry, indx);
                                // callGetAuditActionApi(
                                //     context, theme, actionName, docEntry, indx);
                                notifyListeners();
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ])),
            );
          });
        });
  }

  void apiResponseDialog(BuildContext context, ThemeData theme, String apiRes) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, st) {
            // final theme=Theme.of(context)
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              insetPadding: const EdgeInsets.all(20),
              contentPadding: EdgeInsets.zero,
              content: Container(
                  padding: EdgeInsets.zero,
                  width: Screens.width(context),
                  //  height: Screens.bodyheight(context)*0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      width: Screens.width(context),
                      height: Screens.bodyheight(context) * 0.06,
                      child: Container(
                        width: Screens.width(context) * 0.8,
                        child: Center(
                            child: Text("Alert",
                                style: theme.textTheme.bodyLarge!
                                    .copyWith(color: Colors.white))),
                      ),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(apiRes),
                    ),
                    SizedBox(
                      height: Screens.padingHeight(context) * 0.02,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            foregroundColor: Colors.white,
                            backgroundColor: theme.primaryColor),
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('OK'))
                  ])),
            );
          });
        });
  }

  validateAbort(
    int docEntry,
    BuildContext context,
    ThemeData theme,
  ) async {
    if (formkey[1].currentState!.validate()) {
      await GetAuditCancelApi.getData(docEntry, mycontroller[1].text)
          .then((value) async {
        if (value.stsCode >= 200 && value.stsCode <= 210) {
          apiResponse = value.respDesc;
          isLoading = false;
          Get.back();

          apiResponseDialog(context, theme, apiResponse);
        } else if (value.stsCode >= 400 && value.stsCode <= 410) {
          errorMsg = value.exception;
          Get.back();
          apiResponseDialog(context, theme, errorMsg);
          isLoading = false;
          notifyListeners();
        }
      });
      notifyListeners();
    }
  }

  String apidate = '';
  void showDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ).then((value) {
      if (value == null) {
        return;
      }
      String chooseddate = value.toString();
      var date = DateTime.parse(chooseddate);
      chooseddate = "";
      chooseddate =
          "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
      apidate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      print(apidate);

      mycontroller[0].text = chooseddate;
      notifyListeners();
    });
  }

  File? source1;
  Directory? copyTo;
  Future<File> getPathOFDB() async {
    final dbFolder = await getDatabasesPath();
    File source1 = File('$dbFolder/Verifyt.db');
    return Future.value(source1);
  }

  Future<Directory> getDirectory() async {
    Directory copyTo = Directory("storage/emulated/0/VerifytBackup");
    log('copyTocopyTocopyTo::$copyTo');
    return Future.value(copyTo);
  }

  Future<bool> getPermissionStorage() async {
    try {
      var statusStorage = await Permission.storage.status;
      if (statusStorage.isDenied) {
        Permission.storage.request();
        return Future.value(false);
      }
      if (statusStorage.isGranted) {
        log('storage Permission Allowed');
        return Future.value(true);
      }
    } catch (e) {
      saveDBShowSnackBars("$e", Colors.red);
    }
    return Future.value(false);
  }

  saveDBShowSnackBars(String e, Color color) {
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 3),
      title: "Warning..",
      message: e,
      backgroundColor: Colors.green,
    ));
  }

  Future<String> createDirectory() async {
    try {
      await copyTo!.create();
      String newPath = copyTo!.path;
      createDBFile(newPath);
      return newPath;
    } catch (e) {
      print('datata1111::$e');
      saveDBShowSnackBars("$e", Colors.red);
    }
    return 'null';
  }

  createDBFile(String path) async {
    try {
      String getPath = "$path/Verifyt.db";
      log("getPath::$getPath");
      await source1!.copy(getPath);
      saveDBShowSnackBars("Created!!...", Colors.green);
    } catch (e) {
      log('pathpathpathpath:$path');
      saveDBShowSnackBars("$e", Colors.red);
    }
  }
}

class CheckListselect {
  String? listval;
  int? indx;
  bool? issele;
  CheckListselect({this.indx, this.listval, this.issele});
}

class Checklisttemplate {
  int? templateid;
  Checklisttemplate({required this.templateid});
}

class FilesData {
  String fileBytes;
  String fileName;
  // String filepath;

  FilesData({
    required this.fileBytes,
    required this.fileName,
  });
}

class ViewDetailsData {
  String? actionName;
  int? itemslength;
  int? docEntry;
  String? lasttimestamp;
  ViewDetailsData({
    this.actionName,
    this.itemslength,
    this.docEntry,
    this.lasttimestamp,
  });
}

// DBOperation.insertAuditByDervice(db, getAuditList2);

// for (var i = 0; i < 4; i++) {
//   DBOperation.updateActionTable(i, 'Open', db);
// }
// List<Map<String, Object?>> result2 =
//     await DBOperation.getAuditByDervice(db);
// for (var i = 0; i < result2.length; i++) {
//   getAuditList.add(GetAuditDataModel(
//       auditFrom: result2[i]['AuditFrom'].toString(),
//       user: result2[i]['User'].toString(),
//       percent: result2[i]['Percent'] != null
//           ? double.parse(result2[i]['Percent'].toString())
//           : 0,
//       unitsScanned: result2[i]['UnitsScanned'] != null
//           ? int.parse(result2[i]['UnitsScanned'].toString())
//           : 0,
//       totalItems: result2[i]['TotalItems'] != null
//           ? int.parse(result2[i]['TotalItems'].toString())
//           : 0,
//       auditTo: result2[i]['AuditTo'].toString(),
//       // blockTrans: bool.parse(result2[i][' blockTrans'].toString()),
//       createdBy: result2[i]['CreatedBy'] != null
//           ? int.parse(result2[i]['CreatedBy'].toString())
//           : 0,
//       createdDatetime: result2[i]['CreatedDatetime'].toString(),
//       docDate: result2[i]['DocDate'].toString(),
//       docEntry: result2[i]['DocEntry'] != null
//           ? int.parse(result2[i]['DocEntry'].toString())
//           : 0,
//       docNum: result2[i]['DocNum'] != null
//           ? int.parse(result2[i]['DocNum'].toString())
//           : 0,
//       endDate: result2[i]['EndDate'].toString(),
//       remarks: result2[i]['Remarks'].toString(),
//       // repeat: result2[i]['repeat'] != null
//       //     ? bool.parse(result2[i]['repeat'].toString())
//       //     : false,
//       repeatDay: result2[i]['RepeatDay'] != null
//           ? int.parse(result2[i]['RepeatDay'].toString())
//           : 0,
//       repeatFrequency: result2[i]['RepeatFrequency'].toString(),
//       scheduleName: result2[i]['ScheduleName'].toString(),
//       startDate: result2[i]['StartDate'].toString(),
//       status: result2[i]['Status'].toString(),
//       traceid: result2[i]['Traceid'].toString(),
//       updatedBy: result2[i]['UpdatedBy'] != null
//           ? int.parse(result2[i]['UpdatedBy'].toString())
//           : 0,
//       updatedDatetime: result2[i]['UpdatedDatetime'].toString(),
//       whsCode: result2[i]['WhsCode'] != null
//           ? result2[i]['WhsCode'].toString()
//           : ''));
// .event.toString());
// .type.toString());
// .qrCode.toString());
// .scanTime.toString());
// }
//52141601SD00393
// linemaster limitresult::S0001125241:vue52::.SS UTENSIL FLASK:: 565
// [log] linemaster limitresult::S0001125242:vue53::0 NO OVEL LADDLE:: 767
// [log] linemaster limitresult::S0001125243:vue54::001@:: 784555
// [log] linemaster limitresult::S0001125244:vue55::002 DRESSING TABLE:: 852
// [log] linemaster limitresult::S0001125245:vue56::006 SIL dummy item10:: abcd
// [log] linemaster limitresult::S0001125246:vue57::006 SIL dummy item35:: B001
// [log] linemaster limitresult::S0001125247:vue58::006 SIL dummy item36:: B0011
// [log] linemaster limitresult::S0001125248:vue59::006 SIL dummy item37:: B0012
// [log] linemaster limitresult::S0001125249:vue60::006 SIL dummy item39:: B002
// [log] linemaster limitresult::S0001125250:vue61::006 SIL dummy item41:: B00265