import 'package:door_opener/model/log_model.dart';
import 'package:door_opener/services/firebase.dart';
import 'package:door_opener/views/user_list_view.dart';
import 'package:door_opener/widgets/log_card.dart';
import 'package:door_opener/widgets/log_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Log> logs = new List();
  bool isLoading;
  final SlidableController slidableController = SlidableController();

  @override
  void initState() {
    getList();
    super.initState();
  }

  // Retrive the list of logs when the user open door
  Future getList() async {
    setState(() {
      isLoading = true;
    });
    try {
      logs = await FirebaseServicce.fetchLogs();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future refreshLogList() async {
    logs.clear();
    await getList();
  }

  void deleteData(String href) {
    try {
      FirebaseServicce.deleteLogs(href);
      setState(() {
        logs.removeWhere((element) => element.href == href);
        showSnackBar();
      });
    } catch (e) {
      print(e);
    }
  }

  showSnackBar() {
    final snackBar = SnackBar(
      content: Text('Deleted log'),
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
      body: Center(
          child: isLoading
              ? SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                )
              : logs.isEmpty
                  ? Text(
                      'Empty log list',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 18,
                      ),
                    )
                  : ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: LogCard(
                              log: logs[index],
                              slidableController: slidableController,
                              onDelete: deleteData,
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
