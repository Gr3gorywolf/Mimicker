import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:mimicker/stores/stores_manager.dart';
import "package:system_info/system_info.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimicker/main.dart';
import 'package:flutter_js/javascript_runtime.dart';
import 'package:mimicker/ui/debug_page/debug_page.dart';
import 'package:mimicker/utils/watch_actions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'helpers.dart';
import 'package:mimicker/ui/phone_app/phone_action_list.dart';

class ScriptRunner {
  bool intialized = false;
  Map<String, JavascriptRuntime> instances = {};
  init() async {}
  run(String script) async {
    try {
      var flutterJs = getJavascriptRuntime();
      flutterJs.onMessage('js', (dynamic args) {
        handleMessage(args['action'], args['data'], flutterJs);
      });
      flutterJs.onMessage('', (args) {});
      script = await _compile(script, flutterJs);
      JsEvalResult jsResult = flutterJs.evaluate(script);
      instances[flutterJs.getEngineInstanceId()] = flutterJs;
    } on PlatformException catch (e) {
      print(e.details);
    }
  }

  _compile(String script, JavascriptRuntime runtime) async {
    String mimicker = await rootBundle.loadString("assets/js/mimicker.js");
    script = script.replaceAll("""require("mimicker.js");""", mimicker);
    runtime
        .evaluate("const instanceId = '" + runtime.getEngineInstanceId() + "'");
    return script;
  }

  handleMessage(String type, dynamic data, JavascriptRuntime instance) {
    switch (type) {
      case 'PHONE_ALERT':
        BridgeAction action = null;
        if (data['action'] != null) {
          action = BridgeAction.fromDynamic(data['action']);
        }
        Helpers.showAlert(
            bldCtx, data['title'], data['message'], data['image'], action);
        break;
      case 'WATCH_ALERT':
        BridgeAction action = null;
        if (data['action'] != null) {
          action = BridgeAction.fromDynamic(data['action']);
        }
        WatchActions.showWatchAlert(data['title'], data['message'], data['image'], action);
        break;
      case 'SHOW_PHONE_ACTIONS_LIST':
        List<BridgeAction> actions = [];
        for (var act in data['actions']) {
          actions.add(BridgeAction.fromDynamic(act));
        }
        PhoneActionList.show(bldCtx, data['title'], actions);
        break;
      case 'SHOW_WATCH_ACTIONS_LIST':
        List<BridgeAction> actions = []; 
        for (var act in data['actions']) {
          actions.add(BridgeAction.fromDynamic(act));
        }
        WatchActions.showActionsList(data['title'], actions);
        break;
      case 'LAUNCH_URL':
        launch(data['url']);
        break;
      case 'PHONE_LOADING':
        StoresManager.useMainStore(bldCtx).setLoading(data['isLoading']);
        break;
      case 'WATCH_LOADING':
        WatchActions.setLoading(data['isLoading']);
        break;
      case 'LAUNCH_INTENT':
        AndroidIntent intent =
            AndroidIntent(action: data['action'], data: data['data'], package: data['package'],
                //clear top flag
                flags: [268435456]);
        intent.launch();
        break;
    }
  }
}
