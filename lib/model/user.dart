class User {
  String href;
  String name;
  String data;

  User({this.href, this.name, this.data});

  User.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    name = json['name'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['name'] = this.name;
    data['data'] = this.data;
    return data;
  }

}