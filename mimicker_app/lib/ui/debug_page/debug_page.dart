import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  String exceptionMsg = "";
  DebugPage(this.exceptionMsg);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Script execution error"),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Center(
        child: Text(
          exceptionMsg,
          style: TextStyle(color: Colors.orange),
        ),
      )),
    );
  }
}
