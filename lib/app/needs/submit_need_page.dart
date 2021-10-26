import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:seekhelp/app/database.dart';
import 'package:seekhelp/app/needs/need_model.dart';
import 'package:seekhelp/common_widgets/form_submit_button.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../strings.dart';

class SubmitNeedPage extends StatefulWidget {
  const SubmitNeedPage(
      {@required this.database,
      Key key,
      this.selectedRubrique,
      this.city,
      this.need})
      : super(key: key);
  final Database database;
  final Map<int, String> selectedRubrique;
  final String city;
  final Need need;

  static Future<void> show(BuildContext context, {Database database, Need need}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => SubmitNeedPage(database: database, need: need),
        fullscreenDialog: true,
      ),
    );
  }
  @override
  _SubmitNeedPageState createState() => _SubmitNeedPageState();
}

class _SubmitNeedPageState extends State<SubmitNeedPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRefUsers =
      FirebaseDatabase.instance.reference().child("users");
  DatabaseReference dbRefNeeds =
      FirebaseDatabase.instance.reference().child("needs");
  final dateString = DateFormat('dd MMM yyyy HH:mm').format(DateTime.now());

  TextEditingController besoinController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('fr', null);
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(Strings.appName),
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  '${Strings.requestNeedTitle} ${widget.selectedRubrique.values.first}',
                  style: TextStyle(fontSize: 18.0, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          //card here
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Container(
                  child: TextFormField(
                    controller: besoinController,
                    maxLines: 4,
                    decoration:
                        InputDecoration(labelText: Strings.requestNeedForm),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: isLoading
                ? SizedBox(child: LinearProgressIndicator(), height: 10)
                : Align(
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 150,
                      child: FormSubmitButton(
                        text: Strings.submitButton,
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return Strings.typeYourNeed;
                          } else {
                            //_submitNeed();
                            final need = Need(
                                id: dbRefNeeds.push().key,
                                dateCreation: dateString,
                                userId: firebaseAuth.currentUser.uid,
                                userEmail: firebaseAuth.currentUser.email,
                                rubriqueId:
                                    (widget.selectedRubrique.keys.first + (1))
                                        .toString(),
                                //userCity: await widget.database.fetchUserCity(firebaseAuth.currentUser),
                                title: besoinController.text);
                            await widget.database.submitNeed(context, need);
                          }
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
