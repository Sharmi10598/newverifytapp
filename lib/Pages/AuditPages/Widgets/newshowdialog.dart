
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Constant/Screen.dart';
import 'package:verifytapp/Controllers/AuditController/AuditControllers.dart';

class newshowdialogpage extends StatefulWidget {
   newshowdialogpage({super.key});
   


  @override
  State<newshowdialogpage> createState() => _newshowdialogpageState();
}

class _newshowdialogpageState extends State<newshowdialogpage> {
  @override
  Widget build(BuildContext context) {
    final theme =Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Screens.padingHeight(context)*0.01,
            ),
           Text('${context.read<AuditCtrlProvider>().datatype}',style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
              SizedBox(
              height: Screens.padingHeight(context)*0.01,
            ),
              ValueListenableBuilder<int>(
                valueListenable:context.read<AuditCtrlProvider>(). progressNotifier,
                builder: (context, value, child) {
                  
                  return Column(
                    children: [
                      LinearProgressIndicator(value: value / 100),
                       Text(
                      "$value%", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ],
                  );
                },
              ),
       SizedBox(
              height: Screens.padingHeight(context)*0.01,
            ),
        ],),
      ),

    );
  }
}