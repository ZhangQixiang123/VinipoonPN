import 'package:flutter/material.dart';

import 'LanguagePage.dart';
import 'LoginPage.dart';
import 'ProfilePage.dart';

class SettingsPage extends StatelessWidget {
  final String selectedLanguage;
  final String email;
  final Function(String) onLanguageChanged;

  SettingsPage({required this.email, required this.selectedLanguage, required this.onLanguageChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            selectedLanguage == 'English' ? 'Settings' : '设置',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 5,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text(selectedLanguage == 'English' ? 'Language' : '语言'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LanguagePage(
                            selectedLanguage: selectedLanguage,
                            onLanguageChanged: onLanguageChanged
                        )
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(selectedLanguage == 'English' ? 'Profile' : '个人资料'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          email: email, 
                          onLogout: () => {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            )
                          }
                        ),
                      )
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}