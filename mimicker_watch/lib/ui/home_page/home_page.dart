import 'dart:convert';
import 'dart:math';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mimicker_core/models/alert_dialog_data.dart';
import 'package:mimicker_core/models/api_message.dart';
import 'package:mimicker_core/models/bridge_action.dart';
import 'package:mimicker_watch/stores/stores_manager.dart';
import 'package:mimicker_watch/ui/widgets/full_screen_alert.dart';
import 'package:mimicker_watch/ui/widgets/watch_actions_list.dart';
import 'package:mimicker_watch/utils/runnables.dart';
import 'package:mimicker_watch/main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        case "SET_LOADING":
          var isLoading = msg.message == 'true';
          StoresManager.useMainStore(bldCtx).setLoading(isLoading);
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
          FullScreenAlert.show(
              _ctx, data.title, data.message, data.image, action);
          break;
      }
    };

    Runnables.broadcastScriptList();
    super.initState();
  }

  AlertDialogData getAlertData(String content) {
    return AlertDialogData.fromJson(jsonDecode(content));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    bldCtx = context;
    final _mainStore = StoresManager.useMainStore(context);
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Icon(
        _connected
            ? Icons.bluetooth_connected
            : Icons.bluetooth_disabled_outlined,
        color: Colors.grey,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: LoadingOverlay(
        isLoading: _mainStore.isLoading,
        child: Center(
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
                        Runnables.runScript(i);
                      },
                      child: Container(
                          width: screenSize.width,
                          height: screenSize.height,
                          decoration: BoxDecoration(
                              color: _colors[Random().nextInt(4)]),
                          child: Center(
                            child: Text(
                              i,
                              style: TextStyle(
                                  fontSize: 25.0, color: Colors.white),
                            ),
                          )),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
