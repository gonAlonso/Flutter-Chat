import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pickers/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final isLoading;

  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    File imageFile,
    BuildContext ctx,
  ) _onSubmitForm;

  AuthForm(this._onSubmitForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _username;
  String _password;
  File _userImage;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) return;

    if (!_isLogin && _userImage == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    _formKey.currentState.save();
    widget._onSubmitForm(
      _email.trim(),
      _password?.trim(),
      _username?.trim(),
      _isLogin,
      _userImage,
      context,
    );
    //
  }

  void _pickedImage(File image) {
    _userImage = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: 'Email address',
                    ),
                    onSaved: (val) {
                      _email = val;
                    },
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@'))
                        return 'Please enter a valid email address';
                      else
                        return null;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.sentences,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (val) {
                        _username = val;
                      },
                      validator: (val) {
                        if (val.isEmpty || val.length < 4)
                          return 'Password must be at leas 4 char long';
                        else
                          return null;
                      },
                    ),
                  TextFormField(
                    key: ValueKey('passsword1'),
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    onSaved: (val) {
                      _password = val;
                    },
                    validator: (val) {
                      if (val.isEmpty || val.length < 7)
                        return 'Password must be at leas 7 char long';
                      else
                        return null;
                    },
                  ),
                  SizedBox(height: 12),
                  widget.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          child: Text(_isLogin ? 'LogIn' : 'Sign Up'),
                          onPressed: _trySubmit,
                        ),
                  if (!widget.isLoading)
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'Create new account'
                          : 'I already have an account'),
                      textColor: Theme.of(context).primaryColor,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
