import 'dart:convert';
import 'package:mimicker/main.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/models/api_message.dart';

/**
 * Actions that can be executed on phone from watch
 */
class PhoneActions {
  static executeBridgeAction(BridgeAction action) {
    var parsedAction = null;
    if (action != null) {
      parsedAction = jsonEncode(action.toJson());
    }
    msgApi.sendMessage(jsonEncode(
        ApiMessage(action: "EXECUTE_BRIDGE_ACTION", message: parsedAction)));
  }

  static broadcastScriptList() {
    msgApi.sendMessage(
        jsonEncode(ApiMessage(action: "BROADCAST_SCRIPTS_LIST", message: "")));
  }

  static runScript(String scriptName) {
    msgApi.sendMessage(
        jsonEncode(ApiMessage(action: "RUN_SCRIPT", message: scriptName)));
  }
}
