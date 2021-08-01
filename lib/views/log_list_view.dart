import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/services/firebase.dart';
import 'package:door_opener/views/user_list_view.dart';
import 'package:door_opener/widgets/log_card.dart';
import 'package:door_opener/widgets/log_detail.dart';
import 'package:door_opener/widgets/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading;
  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
  }

  void deleteData(String href) {
    try {
      FirebaseServicce.deleteLogs(href);
      showSnackBar();
    } catch (e) {
      print(e);
    }
  }

  showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Deleted log'),
      backgroundColor: Colors.red,
      duration: Duration(milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseServicce.fetchLogStream().onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasError &&
                snapshot.hasData &&
                snapshot.data != null) {
              List<Log> logs = new List();
              Map<dynamic, dynamic> data = snapshot.data.snapshot.value;
              if (data != null) {
                data.forEach((key, values) {
                  logs.add(new Log(
                      href: key,
                      name: values["name"],
                      data: values["data"],
                      timestamp: values["timestamp"]));
                });
              }
              return logs.isEmpty
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
                            print('tap');
                            if (logs[index].data != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogDetail(
                                        log: logs[index],
                                        deleteLog: deleteData),
                                  ));
                            }
                          },
                          onLongPress: () {
                            PopUp.showPopup(
                                context,
                                "Do you want to remove this log? ",
                                () => deleteData(logs[index].href));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 12),
                            child: LogCard(
                              log: logs[index],
                              slidableController: slidableController,
                              onDelete: deleteData,
                            ),
                          ),
                        );
                      },
                      itemCount: logs == null ? 0 : logs.length,
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
