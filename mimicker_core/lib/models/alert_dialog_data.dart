
class AlertDialogData {
  String title;
  String message;
  String action;
  String image;

  AlertDialogData({this.title, this.message,this.image,this.action});

  AlertDialogData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    action = json['action'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['action'] = this.action;
    data['image'] = this.image;
    return data;
  }
}