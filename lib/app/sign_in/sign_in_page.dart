import 'package:flutter/material.dart';
import 'package:seekhelp/app/sign_in/sign_in_form_manager.dart';

import '../../strings.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
        elevation: 2.0,
      ),
      body: Center(
        child: Form(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(Strings.signInPageTitle,
                  style: TextStyle(fontSize: 36.0, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SignInFormManager.create(context)
              ),
            ],
          ),
        ),
      ),
      //backgroundColor: Colors.grey[200],
    );
  }
}
