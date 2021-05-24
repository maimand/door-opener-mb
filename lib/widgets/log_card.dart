import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/time_utility.dart';
import 'package:door_opener/widgets/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class LogCard extends StatelessWidget {
  const LogCard({
    Key key,
    @required this.log,
    @required this.slidableController,
    @required this.onDelete
  }) : super(key: key);

  final Log log;
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
          onTap: () {
            onDelete(log.href);
          } ,
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.redAccent),
              child: Text('Remove from List',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white))),
        ),
      ],
      child: new Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 12.0),
          child: Container(
            height: 48,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  log.name,
                  style: TextStyle(fontSize: 18),
                ),
                new Text(TimeUtility.getTime(log.timestamp),
                    style: TextStyle(fontSize: 14))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
