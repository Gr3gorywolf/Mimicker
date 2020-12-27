import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/models/alert_dialog_data.dart';
import 'package:mimicker/models/api_message.dart';
import 'package:mimicker/models/scripts_response.dart';
import 'package:mimicker/ui/watch_app/full_screen_alert.dart';
import 'package:mimicker/ui/watch_app/watch_actions_list.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/utils/phone_actions.dart';
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
      ApiMessage msg = ApiMessage.fromJson(jsonDecode(message));
      switch (msg.action) {
        case "SCRIPT_LIST":
          setState(() {
            _scripts =
                (jsonDecode(msg.message) as List<dynamic>).cast<String>();
          });
          break;
        case "SHOW_ACTIONS_LIST":
          var parsedMessage = jsonDecode(msg.message);
          List<BridgeAction> actions = [];
          String title = parsedMessage['title'];
          List<dynamic> parsedActions = jsonDecode(parsedMessage['actions']);

          for (var action in parsedActions) {
            actions.add(BridgeAction.fromDynamic(action));
          }
            print(actions);
          WatchActionsList.show(_ctx, title, actions);
          break;
        case "DISPLAY_ALERT":
          var data = getAlertData(msg.message);
          BridgeAction action = null;
          if (data.action != null) {
            action = BridgeAction.fromDynamic(jsonDecode(data.action));
          }
          FullScreenAlert.show(_ctx, data.title, data.message, action);
          break;
      }
    };

    PhoneActions.broadcastScriptList();
    super.initState();
  }

  AlertDialogData getAlertData(String content) {
    return AlertDialogData.fromJson(jsonDecode(content));
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
                      PhoneActions.runScript(i);
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
