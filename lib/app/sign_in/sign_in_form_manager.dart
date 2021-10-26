import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seekhelp/app/sign_in/sign_in_change_model.dart';
import 'package:seekhelp/common_widgets/form_submit_button.dart';
import 'package:seekhelp/common_widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

import '../../strings.dart';
import '../auth.dart';

class SignInFormManager extends StatefulWidget {
  SignInFormManager({@required this.model});

  final SignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<SignInChangeModel>(
      create: (_) => SignInChangeModel(auth: auth),
      child: Consumer<SignInChangeModel>(
        builder: (_, model, __) => SignInFormManager(model: model),
      ),
    );
  }

  @override
  _SignInFormManagerState createState() => _SignInFormManagerState();
}

class _SignInFormManagerState extends State<SignInFormManager> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  SignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Erreur d\'authentification',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailSubmitValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 16.0),
      _buildPasswordTextField(),
      SizedBox(height: 16.0),
      Padding(
        padding: EdgeInsets.all(20.0),
        child: model.isLoading
            ? SizedBox(child: LinearProgressIndicator(), height: 10)
            : SizedBox(
                child: FormSubmitButton(
                  text: model.primaryButtonText,
                  onPressed: model.canSubmit ? _submit : null,
                ),
              ),
      ),
    ];
  }

  TextFormField _buildPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: Strings.motDePasse,
        enabled: model.isLoading == false,
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextFormField _buildEmailTextField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: Strings.emailLabel,
        enabled: model.isLoading == false,
        errorText: model.emailErrorText,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
