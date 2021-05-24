import 'package:flutter/material.dart';

class PopUp {
  final BuildContext context;
  final String text;
  final Function onConfirm;

  PopUp(this.context, {this.text, this.onConfirm});

  showOptions() {
    FocusScope.of(context).unfocus();
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(text),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w400),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            contentPadding: EdgeInsets.only(left: 32, right: 32, top: 16),
            content: Container(
              height: 100,
              child: Column(
                children: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      )),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                      )),
                ],
              ),
            ),
          );
        });
  }
}