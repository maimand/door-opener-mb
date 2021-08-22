class User {
  String? href;
  String? name;
  String? data;

  User({this.href, this.name, this.data});

  User.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    name = json['name'];
    data = json['data'];
  }

}