class BridgeAction {
  String action;
  String title;
  String instanceId;

  BridgeAction({ this.action, this.title,this.instanceId});

  BridgeAction.fromDynamic(dynamic rawAction){
    action = rawAction['action'];
    title = rawAction['title'];
    instanceId = rawAction['instanceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['title'] = this.title;
    data['instanceId'] = this.instanceId;
    return data;
  }
}