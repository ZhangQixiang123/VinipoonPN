import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinipoo_p_n/generated/l10n.dart';
import 'package:vinipoo_p_n/global.dart';
import 'package:vinipoo_p_n/pages/LanguagePage.dart';
import 'package:vinipoo_p_n/pages/SignUpPage.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  Future<String?> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> _storeUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> _login() async {

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.str_fill_blank)),
      );
    } else {
      setState(() {
        _isLoading = true;
      });

      final url = Uri.parse('$server/api/v1/rest-auth/login/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['key'];
        _storeToken(token);
        _storeUsername(_usernameController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['non_field_errors'] != null
            ? errorData['non_field_errors'][0]
            : 'Authentication failed!';

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(lang.str_error),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(lang.str_ok),
              ),
            ],
          ),
        );
      }
    }
  }

  late S lang;

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
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
                Image.file(File('assets/common/logo.png')),
                SizedBox(height: 20),
                Text(
                  lang.str_sign_in,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: lang.str_username,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoading
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _login,
                                  child: Text(lang.str_sign_in),
                                ),
                            IconButton(
                              icon: Icon(Icons.language),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LanguagePage(),),
                                  );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                          },
                          child: Text(lang.str_no_account + ' ' + lang.str_sign_up),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
