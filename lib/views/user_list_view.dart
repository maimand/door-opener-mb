import 'dart:convert';
import 'dart:io';

import 'package:door_opener/model/user.dart';
import 'package:door_opener/services/service.dart';
import 'package:door_opener/views/add_user_view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserList extends StatefulWidget {
  DatabaseReference databaseReference;
  UserList({this.databaseReference, key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users = new List();

  @override
  void initState() {
    super.initState();
    print('init');
    getList();
  }

  Future getList() async {
    print('loading user list');
    try {
      await widget.databaseReference
          .child("door-opener-a3c06-default-rtdb/user")
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          users.add(new User(name: values["name"], data: values["data"]));
        });
      });
      print('loaded');
      setState(() {
      });
    } catch (e) {
      // TODO
      print(e);
    }
  }

  Future saveUser(String name, File file) async {
    try {
      await Service.createUser(name, file);
      final bytes = file.readAsBytesSync();
      String img64 = base64Encode(bytes);
      users.add(new User(name: name, data: img64));
      setState(() {
      });
    } catch (e) {
      // TODO : add snack bar to show toast
      print(e);
    }
  }

  Future refreshUserList() async {
    users = new List();
    await getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddUserView(onSave: saveUser),
                  ),
                );
              }),
        ],
        title: Text('Users'),
      ),
      body: Center(
          child: new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: new Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      users[index].name,
                      style: TextStyle(fontSize: 14),
                    ),
                    new Image.memory(base64Decode(users[index].data)),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: users == null ? 0 : users.length,
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: refreshUserList,
      ),
    );
  }
}
