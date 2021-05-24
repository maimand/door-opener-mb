import 'dart:convert';
import 'dart:io';
import 'package:door_opener/model/user.dart';
import 'package:door_opener/services/firebase.dart';
import 'package:door_opener/services/service.dart';
import 'package:door_opener/views/add_user_view.dart';
import 'package:door_opener/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class UserList extends StatefulWidget {
  UserList({key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users = new List();
  bool isLoading = true;
  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    print('init');
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

  void deleteData(String name, String href) {
    try {
      Service.deleteUser(name, href);
      setState(() {
        users.removeWhere((element) => element.href == href);
      });
    } catch (e) {
      print(e);
    }
  }

  Future saveUser(String name, File file) async {
    try {
      setState(() {
        final bytes = file.readAsBytesSync();
        String img64 = base64Encode(bytes);
        users.add(new User(name: name, data: img64));
      });
      await Service.createUser(name, file);
    } catch (e) {
      // TODO : add snack bar to show toast
      print(e);
    }
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
                            Service.deleteUser(
                                users[index].name, users[index].href);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: UserCard(
                                user: users[index],
                                slidableController: slidableController,
                                onDelete: deleteData),
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
