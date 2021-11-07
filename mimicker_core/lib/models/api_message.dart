class ApiMessage {
  String action;
  String message;

  ApiMessage({this.action, this.message});

  ApiMessage.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['message'] = this.message;
    return data;
  }
}