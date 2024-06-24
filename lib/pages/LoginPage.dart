import 'dart:io';

import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignIn = true;
  bool _isLoading = false;

  void _toggleForm() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _authenticate() async {
    setState(() {
      _isLoading = true;
    });
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));

    // Implement your authentication logic here
    // For simplicity, we'll assume authentication is always successful

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(email: _emailController.text)),
    );
  }

  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
  }

  @override
  Widget build(BuildContext context) {
    _updateLang();
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(30.0),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.file(new File('img\\logo.png')),

                Text(
                  _isSignIn ? lang.str_sign_in : lang.str_sign_up,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: lang.str_email,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: lang.str_password,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _authenticate,
                        child: Text(_isSignIn ? lang.str_sign_in : lang.str_sign_up),
                      ),
                SizedBox(height: 5),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(_isSignIn
                    ? lang.str_no_account + ' ' + lang.str_sign_up
                    : lang.str_have_account + ' ' + lang.str_sign_in,
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}