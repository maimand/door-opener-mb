import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/time_utility.dart';
import 'package:door_opener/widgets/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LogCard extends StatelessWidget {
  const LogCard(
      {Key key,
      @required this.log,
      @required this.slidableController,
      @required this.onDelete})
      : super(key: key);

  final Log log;
  final SlidableController slidableController;
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
                  log.name,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 12,),
                log.data != null
                    ? Icon(Icons.image, color: Colors.green,)
                    : SizedBox(),
              ]),
              new Text(TimeUtility.getTime(log.timestamp),
                  style: TextStyle(fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }
}
