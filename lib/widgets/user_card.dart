import 'dart:convert';

import 'package:door_opener/model/user.dart';
import 'package:door_opener/widgets/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserCard extends StatelessWidget {
  const UserCard(
      {Key key,
      @required this.user,
      @required this.slidableController,
      @required this.onDelete})
      : super(key: key);

  final User user;
  final SlidableController slidableController;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slidableController,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      secondaryActions: <Widget>[
        GestureDetector(
          onTap: () => new PopUp(context,
                  text: 'Do you want to delete this log?',
                  onConfirm: onDelete(user.name, user.href))
              .showOptions(),
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.redAccent),
              child: Text('Remove from List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white))),
        ),
      ],
      child: Card(
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
      ),
    );
  }
}
