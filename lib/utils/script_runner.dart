import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import "package:system_info/system_info.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/ui/debug_page/debug_page.dart';
import 'package:mimicker/utils/watch_actions.dart';
import 'package:starflut/starflut.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'helpers.dart';
import 'package:mimicker/ui/phone_app/phone_action_list.dart';

class ScriptRunner {
  StarCoreFactory core;
  StarServiceClass service;
  StarSrvGroupClass serviceGroup;
  String helperScript = "";
  String procArch = "";
  List<StarObjectClass> instances = [];
  bool intialized = false;
  init() async {
    if (this.intialized) return;
    //var kernel = SysInfo.kernelBitness.abs().toString();
    var kernelArch = SysInfo.kernelArchitecture.toString();
    procArch = kernelArch.contains("64") ? "arm64-v8a" : "armeabi-v7a";
    bool isAndroid = await Starflut.isAndroid();
    core = await Starflut.getFactory();
    service = await this.core.initSimple("test", "123", 0, 0, []);
    if (isAndroid == true) {
      await Starflut.copyFileFromAssets(
          "python3.6.zip", "flutter_assets/starfiles", null);
      await Starflut.copyFileFromAssets(
          "mimicker.py", "flutter_assets/starfiles", null);
      await Starflut.copyFileFromAssets(
          "py-libs.zip", "flutter_assets/starfiles", null);
      await Starflut.copyFileFromAssets(
          "cacert.pem", "flutter_assets/starfiles", null);
      var libsFile = await rootBundle.loadString("starfiles/libraries.json");
      var libs = jsonDecode(libsFile)['libs'];
      for (var lib in libs) {
        var filePath = "$lib";
        await Starflut.copyFileFromAssets(
            filePath, "flutter_assets/starfiles/py-modules/$procArch", null);
      }
      await Starflut.loadLibrary("libpython3.6m.so");
    }
    serviceGroup = await service["_ServiceGroup"];
    await serviceGroup.initRaw("python36", service);
    this.intialized = true;
  }

  run(String script) async {
    StarObjectClass python =
        await service.importRawContext("python", "", false, "");
    StarObjectClass bridge = await service.newObject([]);
    await python.setValue("_bridge", bridge);
    await python.setValue("_context_id", python.starId);
    await bridge.regScriptProcP("message", (cleObject, paras) {
      var type = paras[0];
      var args = paras.sublist(1);
      try {
        handleMessage(type, args, python);
      } catch (ex) {
        print(ex);
        Navigator.of(bldCtx).push(MaterialPageRoute(
            builder: (ctx) =>
                DebugPage("Error trying to handle the bridge message")));
      }
    });
    var res = await service.runScript("python", script, "", "");
    bool isValid = res[0];
    String exception = res[1];
    instances.add(python);
    if (!isValid) {
      Navigator.of(bldCtx)
          .push(MaterialPageRoute(builder: (ctx) => DebugPage(exception)));
    }
  }

  handleMessage(String type, List<dynamic> args, StarObjectClass instance) {
    switch (type) {
      case 'PHONE_ALERT':
        BridgeAction action = null;
        if (args[2] != null) {
          action = BridgeAction.fromDynamic(args[2]);
        }
        Helpers.showAlert(bldCtx, args[0], args[1], action);
        break;
      case 'WATCH_ALERT':
        BridgeAction action = null;
        if (args[2] != null) {
          action = BridgeAction.fromDynamic(args[2]);
        }
        WatchActions.showWatchAlert(args[0], args[1], action);
        break;
      case 'CALL_FUNC':
        instance.call(args[0], args[1]);
        break;
      case 'SHOW_PHONE_ACTIONS_LIST':
        List<BridgeAction> actions = [];
        print(args[1]);
        for (var act in args[1]) {
          actions.add(BridgeAction.fromDynamic(act));
        }
        PhoneActionList.show(bldCtx, args[0], actions);
        break;
      case 'SHOW_WATCH_ACTIONS_LIST':
        List<BridgeAction> actions = [];
        print(args[1]);
        for (var act in args[1]) {
          actions.add(BridgeAction.fromDynamic(act));
        }
        WatchActions.showActionsList(args[0], actions);
        break;
      case 'LAUNCH_URL':
        launch(args[0]);
        break;
      case 'LAUNCH_INTENT':
        AndroidIntent intent =
            AndroidIntent(action: args[0], data: args[1], package: args[2],
                //clear top flag
                flags: [268435456]);
        intent.launch();
        break;
    }
  }
}
