import 'package:flutter/foundation.dart';
import 'package:seekhelp/app/sign_in/validators.dart';

import '../../strings.dart';
import '../auth.dart';

class SignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  SignInChangeModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthBase auth;
  String email;
  String password;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return Strings.signInButton.toUpperCase();
  }

  bool get canSubmit {
    return emailSubmitValidator.isValid(email) &&
        passwordSignInSubmitValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText =
        submitted && !passwordSignInSubmitValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailSubmitValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    bool isLoading,
    bool submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
