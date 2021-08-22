import 'dart:io';

import 'package:door_opener/services/endpoint.dart';
import 'package:http/http.dart' as http;

class Service {
  static Future createUser(String name, File video, File image) async {
      var request = http.MultipartRequest(
          'POST', Uri.parse(Endpoint.BASE_URL + '/register-face'));
      request.fields.addAll({'name': name});
      request.files.add(await http.MultipartFile.fromPath('video', video.path));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      await request.send();
    
  }

  static Future deleteUser(String? name, String? href) async {
      var request = http.MultipartRequest(
          'DELETE', Uri.parse(Endpoint.BASE_URL + '/delete-face'));
      request.fields.addAll({'name': name!});
      request.fields.addAll({'href': href!});
      await request.send();
  }

  static Future remoteOpenDoor() async {
    var request = http.MultipartRequest('GET', Uri.parse(Endpoint.BASE_URL + '/fakeNotification'));
    await request.send();
  }
}
