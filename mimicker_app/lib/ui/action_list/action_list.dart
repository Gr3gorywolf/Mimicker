import 'package:flutter/material.dart';
import 'package:mimicker/utils/bridge_actions.dart';
import 'package:mimicker_core/models/bridge_action.dart';

class PhoneActionList extends StatelessWidget {
  final String title;
  final List<BridgeAction> actions;
  static show(BuildContext context, String title, List<BridgeAction> actions) {
    showDialog(
        context: context,
        builder: (ctx) {
          return PhoneActionList(title, actions);
        });
  }
  PhoneActionList(this.title, this.actions);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Expanded(
          child: new Wrap(
            children: actions
                .map((action) => ListTile(
                    title: new Text(action.title),
                    onTap: () {
                      BridgeActions.call(action);
                      Navigator.of(context).pop();
                    }))
                .toList(),
          ),
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
      ],
    );
  }
}
