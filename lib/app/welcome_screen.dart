import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seekhelp/app/sign_in/sign_in_page.dart';
import 'package:seekhelp/common_widgets/sign_in_button.dart';

import '../strings.dart';
import 'auth.dart';
import 'signup/register_page.dart';

class WelcomeManager {
  WelcomeManager({@required this.auth, @required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    Key key,
    @required this.manager,
    @required this.isLoading,
  }) : super(key: key);
  final WelcomeManager manager;
  final bool isLoading;

  static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<WelcomeManager>(
          create: (_) => WelcomeManager(auth: auth, isLoading: isLoading),
          child: Consumer<WelcomeManager>(
            builder: (_, manager, __) =>
                WelcomeScreen(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SignInPage(),
      ),
    );
  }

  Future<void> _createAccount(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Center(
      child: Text(
        Strings.welcomePageTitle,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w200),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 80.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 12.0),
          SignInButton(
            key: emailPasswordKey,
            text: Strings.signInWithEmailPasswordButton,
            textColor: Colors.white,
            color: Colors.blue[700],
            onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 16.0),
          SignInButton(
            text: Strings.createAccountButton,
            textColor: Colors.white,
            color: Colors.red[700],
            onPressed: isLoading ? null : () => _createAccount(context),
          ),
        ],
      ),
    );
  }
}
