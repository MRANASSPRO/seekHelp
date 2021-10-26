import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seekhelp/app/splash_screen.dart';
import 'package:seekhelp/strings.dart';
import 'package:provider/provider.dart';

import 'app/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: SplashScreen()
      ),
    );
  }
}
