import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:seekhelp/app/database.dart';
import 'package:seekhelp/app/help/give_help_page.dart';
import 'package:seekhelp/app/links/links_ambassade.dart';
import 'package:seekhelp/app/links/links_soutien.dart';
import 'package:seekhelp/app/needs/submit_need_page.dart';
import 'package:seekhelp/common_widgets/platform_alert_dialog.dart';
import 'package:provider/provider.dart';

import '../../strings.dart';
import '../auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.database, this.uid, this.onSignedOut});

  final Database database;
  final String uid;
  final VoidCallback onSignedOut;

  static const List<Map<int, String>> allRubriques = [
    {0: "Medical Help"},
    {1: "Transportation"},
    {2: "School & Tutoring"},
    {3: "Baby Sitting"},
    {4: "Leisure & Trips"},
    {5: "Housing"},
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, String> selectedRubrique = {0: ""};
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  List<dynamic> allData = [];
  String userCity;
  List<Map<dynamic, dynamic>> lists = [];
  DatabaseReference dbRefUsers =
      FirebaseDatabase.instance.reference().child("users");

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      try {
        final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
        await auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        //widget.onSignedOut();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<String> fetchUserCity() {
    var values;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref
        .child('users')
        .child(firebaseAuth.currentUser.uid)
        .once()
        .then((DataSnapshot snap) {
      if (snap.value != null) {
        lists.clear();
        //var keys = snap.value.keys;
        values = snap.value.values.elementAt(4);
        print('city : $values');
        //return values;
      }
    });
    print('city to return : $values');
    return values;
  }

  Widget myCustomCircles(BuildContext context) {
    return Stack(children: <Widget>[
      //logo
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('images/app_logo.png'),
              ),
            ),
          ),
        ),
      ),
      //Medical Help
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 240),
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[
                myPopMenu(context, 0),
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
      //Transportation
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(220, 0, 0, 120),
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[
                myPopMenu(context, 1),
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
      //School & Tutoring
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(220, 120, 0, 0),
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[
                myPopMenu(context, 2),
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
      //Baby Sitting
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 240, 0, 0),
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[
                myPopMenu(context, 3),
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
      //Leisure & Trips
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 120, 220, 0),
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[
                myPopMenu(context, 4),
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
      //Housing
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 220, 120),
            width: 110,
            height: 110,
            child: Stack(
              children: <Widget>[
                myPopMenu(context, 5),
              ],
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
        ),
      ),
      Positioned(
        child: Align(
        alignment: Alignment.bottomCenter,
          child: Image.asset(
            "images/arc.png",
            //scale: 0.75,
            //fit: BoxFit.none,
            alignment: Alignment.bottomCenter,
          ),
        ),
      ),
      Positioned(
        child: Stack(
          children: [
            //LINKS right
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                constraints: new BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2),
                padding: EdgeInsets.fromLTRB(0, 0, 80, 20),
                child: GestureDetector(
                  child: Text(
                    Strings.contactMe,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinksSoutien(),
                      ),
                    );
                  },
                ),
              ),
            ),
            //LINKS left
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                constraints: new BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2),
                padding: EdgeInsets.fromLTRB(90, 0, 0, 20),
                child: GestureDetector(
                  child: Text(
                    Strings.myWebsite,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LinksAmbassade(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }

  Future<void> selectedItemRedirect(Database database, BuildContext context,
      dynamic value, Map<int, String> selectedCat) async {
    if (value == 1) {
      print('create need');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmitNeedPage(
              database: database,
              city: userCity,
              selectedRubrique: selectedCat),
        ),
      );
    } else {
      print('read needs');
      //print('rubriqueId to pass ${selectedCat.keys.first + 1}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GiveHelpPage(database: database, selectedRubrique: selectedCat),
        ),
      );
    }
  }

  Widget myPopMenu(BuildContext context, int position) {
    return PopupMenuButton(
      onSelected: (value) async {
        selectedRubrique = HomePage.allRubriques[position];
        print(HomePage.allRubriques[position]);
        selectedItemRedirect(new FirebaseRealtimeDb(uid: null), context, value,
            selectedRubrique);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
                Text(Strings.requestNeed)
              ],
            )),
        PopupMenuItem(
            value: 2,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
                Text(Strings.giveHelp)
              ],
            )),
      ],
      //child category text
      child: Center(
        child: Text(
          HomePage.allRubriques[position][position],
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(Strings.appName),
        actions: <Widget>[
          FlatButton(
            child: Text(Strings.logout,
                style: TextStyle(fontSize: 17.0, color: Colors.white)),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: myCustomCircles(context),
    );
  }
}
