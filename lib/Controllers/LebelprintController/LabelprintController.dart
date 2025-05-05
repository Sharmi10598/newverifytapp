import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:verifytapp/Model/AuditModel/AuditActionModel.dart';
import 'package:verifytapp/Model/labelscanModel/LabelscandataModel.dart';
import 'package:verifytapp/driftDB/driftTablecreation.dart';

import '../../driftDB/driftoperation.dart';

class LabelPrintcontrller extends ChangeNotifier {
  init() {
    clearAll();
    getitemcode();
    getstcosnapdata();
    // getscanneddatafromdb();
  }

  clearAll() {
     addLabelscandata.clear();
    showaditinalcolumn=false;
tableColumLoad=false;
    generateload=false;
    testdata.clear();
    mycontroller[0].clear();
    mycontroller[1].clear();
    mycontroller[2].clear();
    mycontroller[3].clear();
    mycontroller[4].clear();
    lbelcode = null;
    itemcodeload = false;
    itemcodeelist.clear();
    exception = '';
    filteritemcodeelist.clear();
    itemcodeelist.clear();
    notifyListeners();
  }

  choosedType(String? val) {
    lbelcode = val;
    notifyListeners();
  }
  bool showaditinalcolumn=false;
  bool tableColumLoad = true;
  List<Labelscandata> getallLabelscandata=[];
  List<Labelscandata> addLabelscandata=[];
  bool generateload=false;
  insertscandata()async{
    generateload=true;

     final database = (await AppDatabase.initialize())!;
    // addLabelscandata.clear();
    int? numbers =int.parse(mycontroller[3].text);
    notifyListeners();
log("numbers::"+numbers.toString());
    var uuid = Uuid();
    if(mycontroller[2].text.toLowerCase() =='s'){
      for(int i=0;i<numbers;i++){
        String? uniqueid= uuid.v4().replaceAll(RegExp(r'[^0-9]'), '');
        
log("uniqueid::"+uniqueid.toString());
        addLabelscandata.add(
          Labelscandata(
            serialNo: "${mycontroller[0].text}${uniqueid.substring(0,10)}", 
            itemCode: "${mycontroller[0].text}", 
            quantity:  "1"
            ),
        );
log("addLabelscandata1::"+addLabelscandata[i].serialNo.toString());
log("addLabelscandata2::"+addLabelscandata[i].itemCode.toString());
log("addLabelscandata3::"+addLabelscandata[i].quantity.toString());
      }

notifyListeners();
     
    }else if(mycontroller[2].text.toLowerCase() =='b'){
      String? uniqueid= uuid.v4().replaceAll(RegExp(r'[^0-9]'), '');;
        addLabelscandata.add(
          Labelscandata(
            serialNo: "${mycontroller[0].text}${uniqueid.substring(0,10)}", 
            itemCode: "${mycontroller[0].text}", 
            quantity:  "${mycontroller[3].text}"
            ),
        );
notifyListeners();
    }
    if(addLabelscandata.isNotEmpty){
      // await driftoperation.insertdriftlablescandataedb(addLabelscandata, database).then((value) async{
generateload=false;
// tableColumLoad=true;
showaditinalcolumn=false;
// await getscanneddatafromdb();
mycontroller[0].clear();
mycontroller[1].clear();
mycontroller[2].clear();
mycontroller[3].clear();
mycontroller[4].clear();
      // });

    }
  }
  getscanneddatafromdb()async{
    getallLabelscandata.clear();
     final database = (await AppDatabase.initialize())!;
     getallLabelscandata = await driftoperation.getlablescandataHeader(database);
     
tableColumLoad=false;
     notifyListeners();
  }
List<LineData> mainstocsnapdata=[];
getstcosnapdata()async{
  mainstocsnapdata.clear();
   final database = (await AppDatabase.initialize())!;
   mainstocsnapdata =
                await driftoperation.getallLineproduct(database);
                 log("getheaderresult::"+mainstocsnapdata.length.toString());
                notifyListeners();
}
  String? lbelcode;
  List<TextEditingController> mycontroller =
      List.generate(50, (i) => TextEditingController());
  bool itemcodeload = false;
  bool serachitemcode = false;
  String? exception = '';
  List<Leveltype> testdata = [];

  List<HeaderData> itemcodeelist = [];
  List<HeaderData> filteritemcodeelist = [];
  getitemcode() async {
    testdata = [
      Leveltype(name: 'Test 1'),
      Leveltype(name: 'Test 2'),
      Leveltype(name: 'Test 3'),
    ];
    itemcodeload = true;
    itemcodeelist.clear();
    filteritemcodeelist.clear();
    notifyListeners();
    final database = (await AppDatabase.initialize())!;
    itemcodeelist = await driftoperation.getallproduct(database);
    log("itemcodeelist" + itemcodeelist.length.toString());
    filteritemcodeelist = itemcodeelist;
    itemcodeload = false;
    notifyListeners();
  }

  checkitemcode(String? itemcodeselect, BuildContext context) {
    log("message::" + itemcodeselect.toString());
    serachitemcode = false;
    bool isitemselected = false;
    isitemselected = false;
    int? index;
    index = null;
    notifyListeners();
    for (int i = 0; i < itemcodeelist.length; i++) {
      if (itemcodeelist[i].itemCode == itemcodeselect) {
        isitemselected = true;
        index = i;
        notifyListeners();
        break;
      }
    }
    if (isitemselected == true) {
      showaditinalcolumn=true;
      mycontroller[0].text = itemcodeelist[index!].itemCode.toString();
      mycontroller[1].text = itemcodeelist[index!].itemName.toString();
      mycontroller[2].text = itemcodeelist[index!].manageBy.toString();
      checkstocsnap(itemcodeelist[index!].itemCode.toString());
      disableKeyBoard(context);
      notifyListeners();
    } else {
      showaditinalcolumn=false;
      showtoastproduct("Entered Item code not in Item Mater..!!", Colors.red);
      notifyListeners();
    }
  }
checkstocsnap(String itemcode){
   
    double? value =0.0;
    
    notifyListeners();
    log("mainstocsnapdata::"+mainstocsnapdata.length.toString());
  for(int i=0;i<mainstocsnapdata.length;i++){
    if(mainstocsnapdata[i].itemCode == itemcode){
 
         value =value! + mainstocsnapdata[i].quantity!;
        
        notifyListeners();
    }
  }
  log("value::"+value.toString());
   mycontroller[4].text =value!.toStringAsFixed(0);
   mycontroller[3].text =mycontroller[4].text.toString() ;
   notifyListeners();
}
  disableKeyBoard(BuildContext context) {
    log('message un focusssss1111:::');
    FocusScope.of(context).unfocus();
    notifyListeners();
  }

  void showtoastproduct(String msg, Color color) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }

  SearchFilteTab(String v) {
    if (v.isNotEmpty) {
      // serachitemcode=true;
      notifyListeners();
      filteritemcodeelist = itemcodeelist
          .where((e) => (e).itemCode!.toLowerCase().contains(v.toLowerCase()))
          .toList();
      notifyListeners();
    } else if (v.isEmpty) {
      serachitemcode = false;
      notifyListeners();
      filteritemcodeelist = itemcodeelist;
      notifyListeners();
    }
  }
}

class Leveltype {
  String? name;
  Leveltype({required this.name});
}
