import 'package:flutter/material.dart';
import 'package:flutter_google_message_api/flutter_google_message_api.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:mimicker/stores/stores_manager.dart';
import 'package:mimicker/ui/home_page/home_page.dart';
import 'package:mimicker/utils/script_runner.dart';

import 'package:mimicker/stores/main_store.dart';

ScriptRunner runner = new ScriptRunner();
late BuildContext bldCtx;
FlutterGoogleMessageApi msgApi = FlutterGoogleMessageApi();
bool isScriptLoading = false;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    runner.init();
    msgApi.init();
    bldCtx = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Provider(
            store: StoresManager.mainStore,
            child: HomePage(
              title: "Mimicker",
            )));
  }
}
