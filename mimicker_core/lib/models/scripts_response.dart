class ScriptResponse {
  String userName;
  List<Scripts> scripts;

  ScriptResponse({this.userName, this.scripts});

  ScriptResponse.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    if (json['scripts'] != null) {
      scripts = new List<Scripts>();
      json['scripts'].forEach((v) {
        scripts.add(new Scripts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    if (this.scripts != null) {
      data['scripts'] = this.scripts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Scripts {
  String file;
  String content;

  Scripts({this.file, this.content});

  Scripts.fromJson(Map<String, dynamic> json) {
    file = json['file'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file'] = this.file;
    data['content'] = this.content;
    return data;
  }
}