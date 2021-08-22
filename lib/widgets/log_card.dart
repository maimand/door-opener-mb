import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/time_utility.dart';
import 'package:flutter/material.dart';

class LogCard extends StatelessWidget {
  const LogCard(
      {
      required this.log,
      required this.onDelete})
     ;

  final Log log;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Container(
          height: 48,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: [
                new Text(
                  log.name!,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 12,),
                log.data != null
                    ? Icon(Icons.image, color: Colors.green,)
                    : SizedBox(),
              ]),
              new Text(TimeUtility.getTime(log.timestamp!),
                  style: TextStyle(fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }
}
