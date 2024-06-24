import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class AddServerPage extends StatefulWidget {
  final Function(String, String) onSave;

  AddServerPage(this.onSave, {super.key});

  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {

  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
  }

  final TextEditingController _serverNameController = TextEditingController();
  final TextEditingController _serverConfigController = TextEditingController();

  void _saveServer() {
    String serverName = _serverNameController.text;
    String serverConfig = _serverConfigController.text;

    if (serverName.isNotEmpty && serverConfig.isNotEmpty) {
      widget.onSave(serverName, serverConfig);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.str_fill_blank)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateLang();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.str_add_server),
        backgroundColor: Color.fromARGB(214, 234, 221, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _serverNameController,
              decoration: InputDecoration(
                labelText: lang.str_server_name,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _serverConfigController,
              decoration: InputDecoration(
                labelText: lang.str_server_configuration,
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveServer,
              child: Text(lang.str_save),
            ),
          ],
        ),
      ),
    );
  }
}