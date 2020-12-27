import 'package:flutter/material.dart';

class WatchContent extends StatelessWidget {
  final Widget child;
  final List<Widget> actions;
  WatchContent({this.child, this.actions});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: actions,
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 25),
            child: child,
          ),
        ),
      ),
    );
  }
}
