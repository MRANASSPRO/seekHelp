import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seekhelp/app/home/home_page.dart';
import 'package:seekhelp/app/signup/register_change_model.dart';
import 'package:seekhelp/common_widgets/form_submit_button.dart';
import 'package:provider/provider.dart';

import '../../strings.dart';
import '../auth.dart';

class RegisterPage extends StatefulWidget {
  //RegisterPage({@required this.model});

  RegisterPage({this.model, this.modelSignIn});

  final RegisterChangeModel model;
  final AuthBase modelSignIn;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<RegisterChangeModel>(
      create: (_) => RegisterChangeModel(auth: auth),
      child: Consumer<RegisterChangeModel>(
        builder: (_, model, __) => RegisterPage(model: model),
      ),
    );
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child("users");

  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telController = TextEditingController();

  TextEditingController numicController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController villeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  RegisterChangeModel get model => widget.model;

  Future<void> persistUser() {
    isLoading = true;
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      dbRef.child(result.user.uid).set({
        "id": result.user.uid,
        "firstName": prenomController.text,
        "lastName": nomController.text,
        "email": emailController.text,
        "age": ageController.text,
        "tel": telController.text,
        "numic": numicController.text,
        "address": adresseController.text,
        "city": villeController.text,
      }).then((res) {
        isLoading = false;
        //widget.model.ville = villeController.text;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(uid: result.user.uid)),
        );
      });
    }).catchError((err) {
      isLoading = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(Strings.registrationFailed),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text(Strings.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    return Fluttertoast.showToast(
        msg: Strings.registrationDone,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Strings.appName)),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              //Name
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: nomController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.enterName;
                    }
                    return null;
                  },
                ),
              ),
              //Email
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.invalidEmailEmpty;
                    } else if (!value.contains('@')) {
                      return Strings.invalidEmailErrorText;
                    }
                    return null;
                  },
                ),
              ),
              //Tel
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: telController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[],
                  decoration: InputDecoration(
                    labelText: "Phone",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.enterPhone;
                    }
                    return null;
                  },
                ),
              ),
              //Address
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: adresseController,
                  decoration: InputDecoration(
                    labelText: "Address",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.enterAddress;
                    }
                    return null;
                  },
                ),
              ),
              //Password
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: Strings.motDePasse,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.invalidPassEmpty;
                    } else if (value.length < 6) {
                      return Strings.passwordMinInput;
                    }
                    return null;
                  },
                ),
              ),
              //confirm pass
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  obscureText: true,
                  controller: confirmPassController,
                  decoration: InputDecoration(
                    labelText: Strings.confirmMdP,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.confirmMdP;
                    } else if (value != passwordController.text) {
                      return Strings.passwordsDontNotMatch;
                    } else if (value.length < 6) {
                      return Strings.passwordMinInput;
                    }
                    return null;
                  },
                ),
              ),
              //FormSubmitButton >s'inscrire
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: isLoading
                    ? SizedBox(child: CircularProgressIndicator(), height: 10)
                    : SizedBox(
                        child: FormSubmitButton(
                          text: Strings.registerButton.toUpperCase(),
                          onPressed: () {
                            _formKey.currentState.validate()
                                ? persistUser()
                                : CircularProgressIndicator();
                          },
                        ),
                      ),
              ),
            ]))));
  }
}
