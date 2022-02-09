import 'dart:async';
import 'dart:convert';

import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/repository/scripts_repository.dart';
import 'package:mimicker/utils/bridge_actions.dart';
import 'package:mimicker_core/models/bridge_action.dart';

class RenderPage extends StatefulWidget {
  final String? script;
  const RenderPage({Key? key, this.script}) : super(key: key);

  @override
  _RenderPageState createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  JsonWidgetData? jsonWidget = null;
  String jsInstanceId = "";
  void handleRender(dynamic toRender) {
    print(toRender);
    setState(() {
      jsonWidget = JsonWidgetData.fromDynamic(toRender);
    });
  }

  void handleRenderState(dynamic state) {
    state.forEach((k, v) => JsonWidgetRegistry.instance.setValue(k, v));
  }

  Widget? buildBody() {
    if (jsonWidget == null) {
      return Center(
        child: Text("Please render something"),
      );
    }
    return jsonWidget?.build(context: context);
  }

  void runCallback(dynamic args) {
    var arg = args[0];
    BridgeActions.call(new BridgeAction(
        instanceId: arg['instanceId'],
        title: 'just a action',
        action: arg['callback']));
  }

  void _init() async {
    var registry = JsonWidgetRegistry.instance;
    registry.clearValues();
    this.jsInstanceId = await runner.run(widget.script ?? '',
        renderCallback: handleRender, renderStateCallback: handleRenderState);
    registry.registerFunctions({
      'runCallback': ({args, required registry}) => () {
            runCallback(args);
          },
    });
    registry.valueStream.every((element) {
      runner.setRenderValues(this.jsInstanceId, registry.values);
      return true;
    });
    runner.instances[this.jsInstanceId]?.executePendingJob();
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Renderer"),
      ),
      body: buildBody(),
    );
  }
}
