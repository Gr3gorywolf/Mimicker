import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/models/alert_dialog_data.dart';
import 'package:mimicker/models/api_message.dart';
import 'package:mimicker/models/scripts_response.dart';
import 'package:mimicker/ui/watch_app/full_screen_alert.dart';
import 'package:mimicker/models/bridge_action.dart';
import '../../main.dart';

class WatchApp extends StatefulWidget {
  WatchApp({Key key}) : super(key: key);

  @override
  _WatchAppState createState() => _WatchAppState();
}

class _WatchAppState extends State<WatchApp> {
  List<String> _scripts = [];
  bool _connected = false;
  BuildContext _ctx;
  var _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.indigo,
    Colors.lime
  ];
  @override
  void initState() {
    msgApi.onConnected = () {
      setState(() {
        _connected = true;
      });
      msgApi.sendMessage(jsonEncode(
          ApiMessage(action: "BROADCAST_SCRIPTS_LIST", message: "")));
    };
    msgApi.onMessage = (String message) {
      print(message);
      ApiMessage msg = ApiMessage.fromJson(jsonDecode(message));
      switch (msg.action) {
        case "SCRIPT_LIST":
          setState(() {
            _scripts =
                (jsonDecode(msg.message) as List<dynamic>).cast<String>();
          });
          break;
        case "DISPLAY_ALERT":
          var data = getAlertData(msg.message);
          BridgeAction action = null;
          if (data.action != null) {
            action = BridgeAction.fromDynamic(jsonDecode(data.action));
          }
          FullScreenAlert.show(_ctx, data.title, data.message,action);
          break;
      }
    };

    msgApi.sendMessage(
        jsonEncode(ApiMessage(action: "BROADCAST_SCRIPTS_LIST", message: "")));
    super.initState();
  }

  AlertDialogData getAlertData(String content) {
    return AlertDialogData.fromJson(jsonDecode(content));
  }

  runScript(String name) {
    msgApi.sendMessage(
        jsonEncode(ApiMessage(action: "RUN_SCRIPT", message: name)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Icon(
        _connected
            ? Icons.bluetooth_connected
            : Icons.bluetooth_disabled_outlined,
        color: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: Center(
        child: Container(
          child: CarouselSlider(
            options: CarouselOptions(
              height: screenSize.height,
              enableInfiniteScroll: false,
              scrollDirection: Axis.vertical,
            ),
            items: _scripts.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return InkWell(
                    onTap: () {
                      runScript(i);
                    },
                    child: Container(
                        width: screenSize.width,
                        height: screenSize.height,
                        decoration:
                            BoxDecoration(color: _colors[Random().nextInt(4)]),
                        child: Center(
                          child: Text(
                            i,
                            style:
                                TextStyle(fontSize: 25.0, color: Colors.white),
                          ),
                        )),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
