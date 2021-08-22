
import 'dart:convert';

import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/time_utility.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LogDetail extends StatelessWidget {
  final Log? log;
  Function? deleteLog;
  LogDetail({this.log, this.deleteLog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () {
                deleteLog!(this.log!.href);
                Navigator.of(context).pop();
              },
              child: Icon(Icons.delete))
        ],
        title: Text("Log Details"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Who : " + log!.name!, style: TextStyle(fontSize: 20)),
                Text("When: " + TimeUtility.getTime(log!.timestamp!),
                    style: TextStyle(fontSize: 20)),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Image.memory(base64Decode(log!.data!)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
