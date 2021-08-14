import 'package:door_opener/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseServicce {
  static final databaseReference = FirebaseDatabase.instance.reference();

  static Query fetchLogStream() {
    Query logs =
        databaseReference.child("door-opener-a3c06-default-rtdb/Images/");
    return logs;
  }

  static void deleteLogs(String href) async {
    databaseReference
        .child("door-opener-a3c06-default-rtdb/Images/" + href)
        .remove();
  }

  static Future<List<User>> fetchUsers() async {
    List<User> users = [];
    await databaseReference
        .child("door-opener-a3c06-default-rtdb/user")
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map<dynamic, dynamic>? values = dataSnapshot.value;
      if (values != null) {
        values.forEach((key, values) {
          users.add(
              new User(href: key, name: values["name"], data: values["data"]));
        });
      }
    });
    return users;
  }
}
