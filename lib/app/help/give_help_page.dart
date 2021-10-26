import 'package:email_launcher/email_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:seekhelp/app/database.dart';
import 'package:seekhelp/strings.dart';
import 'package:intl/date_symbol_data_local.dart';

class GiveHelpPage extends StatefulWidget {
  const GiveHelpPage({@required this.database, Key key, this.selectedRubrique})
      : super(key: key);
  final Database database;
  final Map<int, String> selectedRubrique;

  @override
  _GiveHelpPageState createState() => _GiveHelpPageState();
}

class _GiveHelpPageState extends State<GiveHelpPage> {
  var realtimeDbService = FirebaseDatabase().reference();
  DatabaseReference dbRefNeeds =
      FirebaseDatabase.instance.reference().child('needs');
  List<Map<dynamic, dynamic>> lists = [];

  void prepareHelpEmail(
      String emailTo, String title, String rubriqueName) async {
    print(rubriqueName);
    Email email = Email(
        to: [emailTo],
        cc: [],
        bcc: [],
        subject: "seekHelp - $rubriqueName",
        body: title);

    await EmailLauncher.launch(email);
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr', null);
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(Strings.appName),
      ),
      body: _buildListView(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildListView() {
    return FutureBuilder(
        future: dbRefNeeds
            .orderByChild('rubriqueId')
            .equalTo((widget.selectedRubrique.keys.first + (1)).toString())
            .once(),
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.hasData) {
            lists.clear();
            Map<dynamic, dynamic> values = snapshot.data.value;
            values.forEach((key, values) {
              lists.add(values);
            });
            return new ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      height: 10,
                      color: Colors.transparent,
                    ),
                shrinkWrap: true,
                itemCount: lists.length,
                padding: EdgeInsets.all(10.0),
                itemBuilder: (BuildContext context, int index) {
                  return Column(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: GestureDetector(
                          child: ListTile(
                            title: Text(lists[index]['title']),
                            subtitle: (lists[index]['userCity']
                                    .toString()
                                    .isNotEmpty
                                ? Text(
                                    '${lists[index]['userCity']}\n${(lists[index]['dateCreation'])}')
                                : null),
                            //isThreeLine: true
                            onTap: () {
                              prepareHelpEmail(
                                  lists[index]['userEmail'],
                                  lists[index]['title'],
                                  widget.selectedRubrique.values.first
                                      .toString());
                            },
                          ),
                        ),
                      ),
                    ),
                  ]);
                });
          } else {
            Container(
              child: Center(child: Text("Empty")),
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
