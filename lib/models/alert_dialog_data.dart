
class AlertDialogData {
  String title;
  String message;
  String action;

  AlertDialogData({this.title, this.message,this.action});

  AlertDialogData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['action'] = this.action;
    return data;
  }
}