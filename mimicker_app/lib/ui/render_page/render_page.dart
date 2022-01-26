import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:mimicker/main.dart';

class RenderPage extends StatefulWidget {
  final String? script;
  const RenderPage({Key? key, this.script}) : super(key: key);

  @override
  _RenderPageState createState() => _RenderPageState();
}

class _RenderPageState extends State<RenderPage> {
  JsonWidgetData? jsonWidget = null;
  void handleRender(dynamic toRender) {
    print(toRender);
    setState(() {
      jsonWidget = JsonWidgetData.fromDynamic(toRender);
    });
  }

  Widget? buildBody() {
    if (jsonWidget == null) {
      return Center(
        child: Text("Please render something"),
      );
    }
    return jsonWidget?.build(context: context);
  }

  @override
  void initState() {
    super.initState();
    runner.run(widget.script ?? '', renderCallback: handleRender);
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
