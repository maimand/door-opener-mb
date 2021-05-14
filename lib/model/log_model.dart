class Log {
  String href;
  String name;
  String timestamp;
  String data;

  Log({this.href, this.name, this.timestamp, this.data});

  Log.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    timestamp = json['timestamp'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['timestamp'] = this.timestamp;
    data['data'] = this.data;
    return data;
  }
}