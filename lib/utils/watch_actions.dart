import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/models/alert_dialog_data.dart';
import 'package:mimicker/models/actions_list_data.dart';
import 'package:mimicker/models/api_message.dart';
import 'package:mimicker/models/scripts_response.dart';
import 'package:mimicker/repository/image_repository.dart';
import 'dart:convert';
import '../main.dart';

/**
 * Actions that can be executed on watch from phone
 */
class WatchActions {
  static showWatchAlert(
      String title, String message, String image, BridgeAction action) async {
    var parsedAction = null;
    var imgData = null;
    if (image != null) {
      setLoading(true);
      imgData = await ImageRepository().getImageBase64(image,scaleSize: 120);
      setLoading(false);
    }
    if (action != null) {
      parsedAction = jsonEncode(action.toJson());
    }
    var dialogData = jsonEncode(AlertDialogData(
            message: message,
            title: title,
            image: imgData,
            action: parsedAction)
        .toJson());
    var apiMessage = ApiMessage(action: "DISPLAY_ALERT", message: dialogData);
    msgApi.sendMessage(jsonEncode(apiMessage.toJson()));
  }

  static showActionsList(String title, List<BridgeAction> actions) {
    var serializedActions = jsonEncode(actions);
    var actionsData = jsonEncode(
        ActionsListData(title: title, actions: serializedActions).toJson());
    var apiMessage =
        ApiMessage(action: "SHOW_ACTIONS_LIST", message: actionsData);
    msgApi.sendMessage(jsonEncode(apiMessage.toJson()));
  }

  static setLoading(bool loading) {
    msgApi.sendMessage(jsonEncode(
        ApiMessage(action: "SET_LOADING", message: loading.toString())));
  }

  static sendScriptsList(List<Scripts> scripts) {
    var scriptList = scripts.map((e) => e.file).toList();
    msgApi.sendMessage(jsonEncode(
        ApiMessage(action: "SCRIPT_LIST", message: jsonEncode(scriptList))));
  }
}
