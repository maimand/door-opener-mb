import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/services/firebase.dart';
import 'package:door_opener/services/service.dart';
import 'package:door_opener/views/user_list_view.dart';
import 'package:door_opener/widgets/log_card.dart';
import 'package:door_opener/widgets/log_detail.dart';
import 'package:door_opener/widgets/pop_up.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    required this.title,
  });

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void deleteLog(String href) {
    try {
      FirebaseServicce.deleteLogs(href);
      PopUp.showSnackBar(
          context: context, message: 'Deleted log', color: Colors.red);
    } catch (e) {
      PopUp.showSnackBar(context: context, message: 'Error', color: Colors.red);
    }
  }

  void remoteOpenDoor() {
    try {
      Service.remoteOpenDoor();
      PopUp.showSnackBar(context: context, message: 'Door Open');
    } catch (e) {
      PopUp.showSnackBar(context: context, message: 'Error', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserList(),
                  ),
                );
              }),
          IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () {
                PopUp.showPopup(context, "Do you want to open door? ",
                    Colors.white, () => remoteOpenDoor());
              }),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseServicce.fetchLogStream().onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data != null) {
              List<Log> logs = [];
              Event snap = snapshot.data! as Event;
              Map<dynamic, dynamic> data = snap.snapshot.value;
              data.forEach((key, values) {
                logs.add(new Log(
                    href: key,
                    name: values["name"],
                    data: values["data"],
                    timestamp: values["timestamp"]));
              });
              final reversed = new List.from(logs.reversed);
              return reversed.isEmpty
                  ? Center(
                      child: Text(
                        'Empty log list',
                        style: TextStyle(
                          color: Colors.black26,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (reversed[index].data != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogDetail(
                                        log: reversed[index], deleteLog: deleteLog),
                                  ));
                            }
                          },
                          onLongPress: () {
                            PopUp.showPopup(
                                context,
                                "Do you want to remove this log? ",
                                Colors.red,
                                () => deleteLog(reversed[index].href!));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 12),
                            child: LogCard(
                              log: reversed[index],
                              onDelete: deleteLog,
                            ),
                          ),
                        );
                      },
                      itemCount: reversed.length,
                    );
            }

            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ));
          }),
    );
  }
}
