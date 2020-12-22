import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mimicker/models/api_message.dart';
import 'package:mimicker/models/scripts_response.dart';
import 'package:mimicker/repository/scripts_repository.dart';

import 'package:mimicker/utils/script_runner.dart';

import '../../main.dart';

class PhoneApp extends StatefulWidget {
  PhoneApp({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  _PhoneAppState createState() => _PhoneAppState();
}

class _PhoneAppState extends State<PhoneApp> {
  int _counter = 0;
  List<Scripts> _scripts = [];
  bool _loading = false;

  @override
  void initState() {
    fetchScripts();
    msgApi.onMessage = (String message) {
      ApiMessage msg = ApiMessage.fromJson(jsonDecode(message));
      switch (msg.action) {
        case "RUN_SCRIPT":
          var script =
              _scripts.where((element) => element.file == msg.message).first;
          runner.run(script.content);
          break;
        case "BROADCAST_SCRIPTS_LIST":
          sendScriptsList();
          break;
      }
    };
    super.initState();
  }

  sendScriptsList() {
    var scriptList = _scripts.map((e) => e.file).toList();
    msgApi.sendMessage(jsonEncode(
        ApiMessage(action: "SCRIPT_LIST", message: jsonEncode(scriptList))));
  }

  fetchScripts() async {
    setState(() {
      _loading = true;
    });
    try {
      var result = await ScriptsRepository().getScripts();
      setState(() {
        _scripts = result.scripts;
      });
      sendScriptsList();
    } catch (ex) {
      print(ex);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bldCtx = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: (_loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await fetchScripts();
                  return false;
                },
                child: ListView.builder(
                    itemCount: _scripts.length,
                    itemBuilder: (BuildContext context, int index) {
                      var script = _scripts[index];
                      return ListTile(
                        onTap: () {
                          runner.run(script.content);
                        },
                        leading: Icon(Icons.code),
                        title: Text(script.file),
                      );
                    }),
              )) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
