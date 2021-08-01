class Log {
  String? href;
  String? name;
  String? timestamp;
  String? data;

  Log({this.href, this.name, this.timestamp, this.data});

  Log.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    timestamp = json['timestamp'];
    data = json['data'];
  }
}
