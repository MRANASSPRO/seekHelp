import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:seekhelp/app/home/home_page.dart';
import 'package:seekhelp/app/needs/need_model.dart';
import 'package:seekhelp/common_widgets/platform_alert_dialog.dart';
import 'package:seekhelp/strings.dart';

abstract class Database {
  Future<void> submitNeed(BuildContext context, Need need);

  Stream<Event> needsStream(Map<int, String> selectedRubrique);
}

class FirebaseRealtimeDb implements Database {
  FirebaseRealtimeDb({this.uid});

  final String uid;

  var values;

  List<Map<dynamic, dynamic>> lists = [];

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRefUsers =
      FirebaseDatabase.instance.reference().child("users");
  DatabaseReference dbRefNeeds =
      FirebaseDatabase.instance.reference().child("needs");
  String usrCity;

  @override
  Future<void> submitNeed(BuildContext context, Need need) async {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var city;
    ref
        .child('users')
        .child(firebaseAuth.currentUser.uid)
        .once()
        .then((DataSnapshot snap) {
      print('snap.value ${snap.value}');
      if (snap.value != null) {
        city = snap.value.values.elementAt(4);
        usrCity = city;
        print('city : $city');
      }
    }).then((value) => dbRefNeeds.child(need.id).set({
              'id': need.id,
              'dateCreation': need.dateCreation,
              'rubriqueId': need.rubriqueId,
              'userId': need.userId,
              'userCity': usrCity,
              'userEmail': need.userEmail,
              'title': need.title,
            }).then((res) async {
              final bool needSaved = await PlatformAlertDialog(
                title: Strings.needSavedPopupTitle,
                content: Strings.needSavedPopupContent,
                defaultActionText: Strings.ok,
              ).show(context);
              if (needSaved == true) {
                print("need submitted");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false);
              }
            }));
  }

  @override
  Stream<Event> needsStream(
          Map<int, String> selectedRubrique) =>
      dbRefNeeds.orderByChild("rubriqueId").equalTo(selectedRubrique).onValue;
}
