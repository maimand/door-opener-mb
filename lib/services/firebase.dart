import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseServicce {
  static final databaseReference = FirebaseDatabase.instance.reference();

  static Future<List<Log>> fetchLogs() async {
    List<Log> logs = new List();
    try {
      await databaseReference
          .child("door-opener-a3c06-default-rtdb/Images")
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        if (values != null) {
          values.forEach((key, values) {
            logs.add(new Log(
                href: key,
                name: values["name"],
                data: values["data"],
                timestamp: values["timestamp"]));
          });
        }
      });
    } catch (e) {
      //TODO: Add error loading view 
      print(e);
    }
    //if error, return empty list
    return logs;
  }

  static void deleteLogs(String href) async {
    try {
      databaseReference
          .child("door-opener-a3c06-default-rtdb/Images/" + href)
          .remove();
    } catch (e) {
      print(e);
    }
  }

  static Future<List<User>> fetchUsers() async {
    List<User> users = new List();
    try {
      await databaseReference
          .child("door-opener-a3c06-default-rtdb/user")
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        if (values != null) {
          values.forEach((key, values) {
            users.add(new User(
              href: key,
              name: values["name"], 
              data: values["data"]));
          });
        }
      });
      print('loaded');
    } catch (e) {
      // TODO
      print(e);
    }
    //if error, return empty list
    return users;
  }

}