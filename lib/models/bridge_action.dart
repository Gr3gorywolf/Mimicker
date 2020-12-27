class BridgeAction {
  List<dynamic> args;
  String function;
  String name;
  String context;

  BridgeAction({this.args, this.function, this.name,this.context});

  BridgeAction.fromDynamic(dynamic rawAction){
    args =  rawAction['args'];
    function = rawAction['function'];
    name = rawAction['name'];
    context = rawAction['context'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['args'] = this.args;
    data['function'] = this.function;
    data['name'] = this.name;
    data['context'] = this.context;
    return data;
  }
}