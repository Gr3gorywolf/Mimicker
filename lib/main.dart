import 'package:flutter/material.dart';
import 'package:flutter_google_message_api/flutter_google_message_api.dart';
import 'package:mimicker/constants/app.dart';
import 'package:mimicker/ui/phone_app/phone_app.dart';
import 'package:mimicker/ui/watch_app/watch_app.dart';
import 'package:mimicker/utils/script_runner.dart';
import 'package:wakelock/wakelock.dart';
ScriptRunner runner = new ScriptRunner();
BuildContext bldCtx;
FlutterGoogleMessageApi msgApi = FlutterGoogleMessageApi();
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
    if (APP_TARGET == 'phone') {
      runner.init();
    } else {
      Wakelock.enable();
    }
    msgApi.init();
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
        home: (APP_TARGET == 'phone')
            ? PhoneApp(
                title: "Mimicker",
              )
            : WatchApp());
  }
}
