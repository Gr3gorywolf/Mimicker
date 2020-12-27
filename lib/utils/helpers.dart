import 'package:mimicker/models/bridge_action.dart';
import 'package:starflut/starflut.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/utils/bridge_actions.dart';
import 'package:mimicker/main.dart';

class Helpers {
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
                      BridgeActions.call(action);
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
