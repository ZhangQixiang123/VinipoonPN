import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  LanguagePage(
      {required this.selectedLanguage, required this.onLanguageChanged, super.key});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
  }

  void _saveLanguage() {
    widget.onLanguageChanged(_selectedLanguage);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language selected: $_selectedLanguage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            RadioListTile<String>(
              title: Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              selected: _selectedLanguage == 'English',
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('中文（简体）'),
              value: 'Chinese',
              groupValue: _selectedLanguage,
              selected: _selectedLanguage == 'Chinese',
              onChanged: (String? value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveLanguage,
              child: Text('Save Language'),
            ),
          ],
        ),
      ),
    );
  }
}
