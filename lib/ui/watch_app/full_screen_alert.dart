import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';

class FullScreenAlert extends StatelessWidget {
  final String title;
  final String msg;
  const FullScreenAlert({Key key, this.title, this.msg}) : super(key: key);
  static Function show(BuildContext ctx, String title, String msg) {
    showDialog(
        context: ctx,
        builder: (ctx) {
          return (FullScreenAlert(
            title: title,
            msg: msg,
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => {Navigator.of(context).pop()},
        child: Icon(Icons.close),
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    msg,
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
