import 'package:flutter/foundation.dart';

import '../../strings.dart';
import '../auth.dart';

class RegisterChangeModel with ChangeNotifier {
  RegisterChangeModel({
    @required this.auth,
    this.nom = '',
    this.prenom = '',
    this.email = '',
    this.age = 0,
    this.tel = 0,
    this.numic = '',
    this.adresse = '',
    this.ville = '',
    this.password = '',
    this.confirmPass = '',
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthBase auth;
  String nom;
  String prenom;
  String email;
  int age;
  int tel;
  String numic;
  String adresse;
  String ville;
  String password;
  String confirmPass;
  bool isLoading;
  bool submitted;

  String get primaryButtonText {
    return Strings.registerButton.toUpperCase();
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String nom,
    String prenom,
    String email,
    int age,
    int tel,
    String numic,
    String adresse,
    String ville,
    String password,
    String confirmPass,
    bool isLoading,
    bool submitted,
  }) {
    this.nom = password ?? this.nom;
    this.prenom = password ?? this.prenom;
    this.email = email ?? this.email;
    this.age = password ?? this.age;
    this.tel = password ?? this.tel;
    this.numic = password ?? this.numic;
    this.adresse = password ?? this.adresse;
    this.ville = password ?? this.ville;
    this.password = password ?? this.password;
    this.confirmPass = password ?? this.confirmPass;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
