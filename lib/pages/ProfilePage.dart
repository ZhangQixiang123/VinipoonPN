import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';
import 'package:vinipoo_p_n/global.dart';
import 'package:http/http.dart' as http;

import '../generated/l10n.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late S lang;

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  Future<String?> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<String?> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> _clearUsername() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
  }

  Future<void> _logout() async {
    final url = '$server/api/v1/rest-auth/logout/';
    final token = await _retrieveToken();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      await _clearToken();
      await _clearUsername();
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(lang.str_error),
          content: Text(lang.str_logout_fail),
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

  @override
  Widget build(BuildContext context) {
    _updateLang();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.str_profile),
        backgroundColor: Color.fromARGB(214, 234, 221, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      lang.str_profile,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<String?>(
                      future: _getUsername(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(lang.str_error + ' ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          return Text(lang.str_no_username_found);
                        } else {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text(lang.str_username),
                            subtitle: Text(snapshot.data!),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: Provider.of<VPNConnectionModel>(context, listen: false).isConnected
                        ? null
                        :_logout,
                      child: Provider.of<VPNConnectionModel>(context, listen: false).isConnected
                        ? Text(lang.str_please_disconnect)
                        : Text(lang.str_logout),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
