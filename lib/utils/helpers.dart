import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/models/alert_dialog_data.dart';
import 'package:mimicker/models/api_message.dart';

class Helpers {
  static showWatchAlert(String title, String message) {
    var dialogData = jsonEncode(AlertDialogData(message: message, title: title).toJson());
    var apiMessage = ApiMessage(action:"DISPLAY_ALERT",message: dialogData);
    msgApi.sendMessage(
      jsonEncode(apiMessage.toJson()));
  }

  static showAlert(BuildContext ctx, String title, String message) {
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
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
