import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/models/api_message.dart';
import 'package:mimicker/ui/widgets/watch_content.dart';
import 'package:mimicker/utils/phone_actions.dart';

class FullScreenAlert extends StatelessWidget {
  final String title;
  final String msg;
  final String encodedImg;
  final BridgeAction action;
  const FullScreenAlert(
      {Key key, this.title, this.msg, this.encodedImg, this.action})
      : super(key: key);
  static Function show(BuildContext ctx, String title, String msg,
      String encodedImg, BridgeAction action) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return (FullScreenAlert(
            title: title,
            msg: msg,
            encodedImg: encodedImg,
            action: action,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List imgBytes = null;
    if (encodedImg != null) {
      imgBytes = base64.decode(encodedImg);
    }
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
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      children: [
        (imgBytes != null)
            ? Container(
                child: Center(
                  child: Image.memory(
                    imgBytes,
                    fit: BoxFit.cover,
                    height: 80,
                    width: 80,
                  ),
                ),
                padding: EdgeInsets.all(5),
              )
            : Padding(
                padding: EdgeInsets.all(0),
              ),
        Text(
          msg,
          style: TextStyle(fontSize: 12),
        )
      ],
    );
  }
}
