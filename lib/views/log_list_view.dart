import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/time_utility.dart';
import 'package:door_opener/views/user_list_view.dart';
import 'package:door_opener/widgets/log_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Log> logs = new List();
  @override
  void initState() {
    print('init');
    getList();
    super.initState();
  }

  // Retrive the list of logs when the user open door
  Future getList() async {
    try {
      await databaseReference
          .child("door-opener-a3c06-default-rtdb/Images")
          .once()
          .then((DataSnapshot dataSnapshot) {
        Map<dynamic, dynamic> values = dataSnapshot.value;
        values.forEach((key, values) {
          logs.add(new Log(
              href: key,
              name: values["name"],
              data: values["data"],
              timestamp: values["timestamp"]));
        });
      });
      setState(() {});
    } catch (e) {
      //TODO: Add error loading view 
      print(e);
    }
  }

  Future refreshLogList () async {
    logs = new List();
    await getList();
  }

  void deleteData(String href) {
    try {
      databaseReference
          .child("door-opener-a3c06-default-rtdb/Images/" + href)
          .remove();
      logs.removeWhere((element) => element.href == href);
      setState(() {
      });
    } catch (e) {
      print(e);
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
                    builder: (context) => UserList(
                      databaseReference: databaseReference,
                    ),
                  ),
                );
              }),
        ],
      ),
      body: Center(
          child: new ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LogDetail(
                      log: logs[index],
                      deleteLog: deleteData
                ),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: new Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        logs[index].name,
                        style: TextStyle(fontSize: 14),
                      ),
                      new Text(TimeUtility.getTime(logs[index].timestamp),
                          style: TextStyle(fontSize: 14))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: logs == null ? 0 : logs.length,
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: refreshLogList,
      ),
    );
  }
}
