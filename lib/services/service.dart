
import 'dart:io';

import 'package:http/http.dart' as http;

class Service {
  //TODO: Update BASE_URL
  static const String BASE_URL = 'http://e46b5b79436f.ngrok.io'; 

  static Future createUser(String name, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse( BASE_URL + '/register-face'));
    request.fields.addAll({
      'name': name
    });
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  static Future deleteUser(String? name, String? href) async {
    var request = http.MultipartRequest('DELETE', Uri.parse( BASE_URL +'/delete-face'));
    request.fields.addAll({
      'name': name!
    });
    request.fields.addAll({
      'href': href!
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }
}
