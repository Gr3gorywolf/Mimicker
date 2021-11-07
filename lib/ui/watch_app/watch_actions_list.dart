import 'package:flutter/material.dart';
import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/ui/widgets/watch_content.dart';
import 'package:mimicker/utils/phone_actions.dart';

class WatchActionsList extends StatelessWidget {
  final String title;
  final List<BridgeAction> actions;
  WatchActionsList(this.title, this.actions);
  static show(BuildContext ctx, String title, List<BridgeAction> actions) {
    showDialog(
        context: ctx,
        builder: (cont) {
          return WatchActionsList(title, actions);
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
          )
        ],
        title: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
          children: actions
              .map((action) => Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(action.title),
                      onPressed: () {
                        PhoneActions.executeBridgeAction(action);
                        //Navigator.of(context).pop();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                    ),
                  ))
              .toList(),
        );
  }
}
