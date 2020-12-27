class ActionsListData {
  String title;
  String actions;

  ActionsListData({this.title, this.actions});

  ActionsListData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    actions = json['actions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['actions'] = this.actions;
    return data;
  }
}
