class User {
  String name;
  String data;

  User({this.name, this.data});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['data'] = this.data;
    return data;
  }
}