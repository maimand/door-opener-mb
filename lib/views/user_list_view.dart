import 'dart:convert';
import 'dart:io';
import 'package:door_opener/model/user.dart';
import 'package:door_opener/services/firebase.dart';
import 'package:door_opener/services/service.dart';
import 'package:door_opener/views/add_user_view.dart';
import 'package:door_opener/widgets/pop_up.dart';
import 'package:door_opener/widgets/user_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserList extends StatefulWidget {
  UserList({key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getList();
  }

  Future getList() async {
    setState(() {
      isLoading = true;
    });
    try {
      users = await FirebaseServicce.fetchUsers();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteData(String? name, String? href) {
    try {
      Service.deleteUser(name, href);
      setState(() {
        users.removeWhere((element) => element.href == href);
        showSnackBar("Deleted user", Colors.redAccent);
      });
    } catch (e) {
      print(e);
    }
  }

  Future saveUser(String name, File file) async {
    try {
      await Service.createUser(name, file);
      setState(() {
        final bytes = file.readAsBytesSync();
        String img64 = base64Encode(bytes);
        users.add(new User(name: name, data: img64));
        showSnackBar("Created user", Colors.greenAccent);
      });

    } catch (e) {
      showSnackBar("Fail create user", Colors.red);
      print(e);
    }
  }

  showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future refreshUserList() async {
    setState(() {
      users.clear();
    });
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
          child: isLoading
              ? SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                )
              : users.isEmpty
                  ? Text(
                      'Empty user list',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 18,
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onLongPress: () {
                            PopUp.showPopup(
                                context,
                                "Do you want to remove this user? ",
                                () => deleteData(users[index].name, users[index].href));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: UserCard(
                                user: users[index],
                                ),
                          ),
                        );
                      },
                      itemCount: users.length,
                    )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: refreshUserList,
      ),
    );
  }
}
