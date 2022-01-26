import 'package:flutter_store/flutter_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/utils/bridge_actions.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/stores/main_store.dart';
import 'package:mimicker_core/models/bridge_action.dart';

class Helpers { 
  static scriptHasRender(String script){
    return script.contains('render(');
  }
  static showAlert(BuildContext ctx, String title, String message,
      String? imgUrl, BridgeAction? action) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (imgUrl != null)
                    ? Container(
                        child: Center(
                          child: Image.network(
                            imgUrl,
                            fit: BoxFit.cover,
                            height: 120,
                            width: 120,
                          ),
                        ),
                        padding: EdgeInsets.all(5),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      ),
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
                    child: Text(action.title),
                    onPressed: () {
                      BridgeActions.call(action);
                      Navigator.of(context).pop();
                    },
                  )
                : Container()
          ],
        );
      },
    );
  }
}
