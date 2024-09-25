import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verifytapp/Controllers/ConfigPageController/ConfigScreenController.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ConfigurationPage extends StatefulWidget {
  ConfigurationPage({Key? key}) : super(key: key);

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  // StreamSubscription? _intentDataStreamSubscription;
  // List<SharedMediaFile>? _sharedFiles;
  // String? _sharedText;
  @override
  void initState() {
    // ignore: todo
    super.initState();

    String? pagename;
    int? docEntry;
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty) {
        print("dattaa: " + message.data["DocEntry"].toString());
        docEntry = int.parse(message.data["DocEntry"].toString());
        pagename = message.data["NaviScreen"].toString();
        // await checkLogin(pagename, docEntry);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<ConfigController>().showVersion();
      context.read<ConfigController>().checkStartingPage(pagename, docEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    throw Container();
  }
}
