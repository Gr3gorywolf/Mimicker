import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/models/api_message.dart';
import 'package:mimicker/ui/widgets/watch_content.dart';
import 'package:mimicker/utils/phone_actions.dart';

class FullScreenAlert extends StatelessWidget {
  final String title;
  final String msg;
  final BridgeAction action;
  const FullScreenAlert({Key key, this.title, this.msg, this.action})
      : super(key: key);
  static Function show(
      BuildContext ctx, String title, String msg, BridgeAction action) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return (FullScreenAlert(
            title: title,
            msg: msg,
            action: action,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return WatchContent(
        actions: [
          Container(
            margin: EdgeInsets.all(5),
            child: FloatingActionButton(
              mini: true,
              heroTag: null,
              onPressed: () => {Navigator.of(context).pop()},
              child: Icon(Icons.close),
            ),
          ),
          (action != null)
              ? Container(
                  margin: EdgeInsets.all(5),
                  child: FloatingActionButton(
                    mini: true,
                    heroTag: null,
                    onPressed: () {
                      PhoneActions.executeBridgeAction(action);
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.navigate_next),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(0),
                )
        ],
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      msg,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
