import 'dart:convert';
import 'package:mimicker/models/bridge_action.dart';
import 'package:starflut/starflut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/models/alert_dialog_data.dart';
import 'package:mimicker/models/api_message.dart';

class Helpers {
  static callBridgeAction(BridgeAction action) {
    runner.instances
        .where((element) => element.starId == action.context)
        .first
        .call(action.function, action.args);
  }

  static showWatchAlert(String title, String message, BridgeAction action) {
    var parsedAction = null;
    if (action != null) {
      parsedAction = jsonEncode(action.toJson());
    }
    var dialogData = jsonEncode(
        AlertDialogData(message: message, title: title, action: parsedAction)
            .toJson());
    var apiMessage = ApiMessage(action: "DISPLAY_ALERT", message: dialogData);
    msgApi.sendMessage(jsonEncode(apiMessage.toJson()));
  }

  static showAlert(
      BuildContext ctx, String title, String message, BridgeAction action) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            (action != null)
                ? TextButton(
                    child: Text(action.name),
                    onPressed: () {
                      callBridgeAction(action);
                      Navigator.of(context).pop();
                    },
                  )
                : null
          ],
        );
      },
    );
  }
}
