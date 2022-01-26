import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:mimicker/stores/stores_manager.dart';
import 'package:mimicker_core/models/bridge_action.dart';
import "package:system_info/system_info.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimicker/main.dart';
import 'package:flutter_js/javascript_runtime.dart';
import 'package:mimicker/ui/debug_page/debug_page.dart';
import 'package:mimicker/utils/runnables.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers.dart';
import 'package:mimicker/ui/action_list/action_list.dart';

class ScriptRunner {
  bool intialized = false;
  Map<String, JavascriptRuntime> instances = {};
  Function(dynamic)? renderCallback = null;
  init() async {}
  run(String script, {Function(dynamic)? renderCallback = null}) async {
    this.renderCallback = renderCallback;
    try {
      var flutterJs = getJavascriptRuntime();
      flutterJs.onMessage('js', (dynamic args) {
        handleMessage(args['action'], args['data'], flutterJs);
      });
      flutterJs.onMessage('', (args) {});
      script = await _compile(script, flutterJs);
      JsEvalResult jsResult = flutterJs.evaluate(script);
      instances[flutterJs.getEngineInstanceId()] = flutterJs;
      if (jsResult.isError) {
        Navigator.push(
            bldCtx,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    DebugPage(jsResult.stringResult)));
      }
      return flutterJs.getEngineInstanceId();
    } on PlatformException catch (e) {
      print(e.details);
      return "";
    }
  }

  setRenderValues(instanceId, data) {
    runner.instances[instanceId]?.evaluate(
        """renderValues = JSON.parse('${jsonEncode(data)}')""");
  }

  _compile(String script, JavascriptRuntime runtime) async {
    String mimicker = await rootBundle.loadString("assets/js/mimicker.js");
    script = script.replaceAll("""require("mimicker.js");""", mimicker);
    runtime
        .evaluate("""
        let renderValues= {}
        let instanceId = '${runtime.getEngineInstanceId()}'
        
        """);
    return script;
  }

  handleMessage(String type, dynamic data, JavascriptRuntime instance) {
    switch (type) {
      case 'PHONE_ALERT':
        BridgeAction? action = null;
        if (data['action'] != null) {
          action = BridgeAction.fromDynamic(data['action']);
        }
        Helpers.showAlert(
            bldCtx, data['title'], data['message'], data['image'], action);
        break;
      case 'WATCH_ALERT':
        BridgeAction? action = null;
        if (data['action'] != null) {
          action = BridgeAction.fromDynamic(data['action']);
        }
        Runnables.showWatchAlert(
            data['title'], data['message'], data['image'], action);
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
        Runnables.showActionsList(data['title'], actions);
        break;
      case 'RENDER':
        if (renderCallback != null) {
          renderCallback!(data);
        }
        break;
      case 'LAUNCH_URL':
        launch(data['url']);
        break;
      case 'PHONE_LOADING':
        StoresManager.useMainStore(bldCtx).setLoading(data['isLoading']);
        break;
      case 'WATCH_LOADING':
        Runnables.setLoading(data['isLoading']);
        break;
      case 'LAUNCH_INTENT':
        AndroidIntent intent = AndroidIntent(
            action: data['action'],
            data: data['data'],
            package: data['package'],
            //clear top flag
            flags: [268435456]);
        intent.launch();
        break;
    }
  }
}
