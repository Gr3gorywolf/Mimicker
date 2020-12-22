import 'dart:convert';
import "package:system_info/system_info.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/ui/debug_page/debug_page.dart';
import 'package:starflut/starflut.dart';

import 'helpers.dart';

class ScriptRunner {
  StarCoreFactory core;
  StarServiceClass service;
  StarSrvGroupClass serviceGroup;
  String helperScript = "";
  String procArch = "";
  bool intialized = false;
  init() async {
    if(this.intialized) return;
    //var kernel = SysInfo.kernelBitness.abs().toString();
    var kernelArch = SysInfo.kernelArchitecture.toString();
    procArch = kernelArch.contains("64") ? "arm64-v8a" : "armeabi-v7a";
    bool isAndroid = await Starflut.isAndroid();
    core = await Starflut.getFactory();
    service = await this.core.initSimple("test", "123", 0, 0, []);
    if (isAndroid == true) {
      await Starflut.copyFileFromAssets("python3.6.zip",
          "flutter_assets/starfiles", null); //desRelatePath must be null
      await Starflut.loadLibrary("libpython3.6m.so");
      var dir = await Starflut.getNativeLibraryDir();
      var libs = jsonDecode(
          await rootBundle.loadString("starfiles/libraries.json"))['libs'];
      for (var lib in libs) {
        await Starflut.copyFileFromAssets("$procArch/$lib", null, null);
      }
    }
    serviceGroup = await service["_ServiceGroup"];
    await serviceGroup.initRaw("python36", service);
    await core.regMsgCallBackP(
        (int serviceGroupID, int uMsg, Object wParam, Object lParam) async {
      print("$serviceGroupID  $uMsg   $wParam   $lParam");
      return null;
    });
    this.helperScript = await rootBundle.loadString("starfiles/helpers.py");
    service.runScript("python", this.helperScript, "", "");
    this.intialized = true;
  }

  run(String script) async {
    StarObjectClass python =
        await service.importRawContext("python", "", false, "");
    StarObjectClass bridge = await service.newObject([]);
    await python.setValue("_bridge", bridge);
    await bridge.regScriptProcP("message", (cleObject, paras) {
      var type = paras[0];
      var args = paras.sublist(1);
      handleMessage(type, args);
    });
    var res = await service.runScript("python", script, "", "");
    bool isValid = res[0];
    String exception = res[1];
    if (!isValid) {
      Navigator.of(bldCtx)
          .push(MaterialPageRoute(builder: (ctx) => DebugPage(exception)));
    }
  }

  handleMessage(String type, List<dynamic> args) {
    switch (type) {
      case 'PHONE_ALERT':
        Helpers.showAlert(bldCtx, args[0], args[1]);
        break;
      case 'WATCH_ALERT':
        Helpers.showWatchAlert(args[0], args[1]);
        break;
    }
  }
}
