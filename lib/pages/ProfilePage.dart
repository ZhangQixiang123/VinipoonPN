import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class ProfilePage extends StatefulWidget {
  final String email;
  final VoidCallback onLogout;

  ProfilePage({required this.email, required this.onLogout, super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                    borderRadius: BorderRadius.circular(10.0)),
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
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(lang.str_email),
                        subtitle: Text(widget.email),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: widget.onLogout,
                        child: Text(lang.str_logout),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}