import 'dart:convert';
import 'package:door_opener/model/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: MemoryImage(
                        base64Decode(user.data),
                      ))),
            ),
            SizedBox(width: 20),
            new Text(
              user.name,
              style: TextStyle(fontSize: 23),
            ),
          ],
        ),
      ),
    );
  }
}
