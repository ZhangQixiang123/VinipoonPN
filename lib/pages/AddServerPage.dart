import 'package:flutter/material.dart';

class AddServerPage extends StatefulWidget {
  final Function(String, String) onSave;

  AddServerPage(this.onSave, {super.key});

  @override
  _AddServerPageState createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
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
        SnackBar(content: Text('Please fill out all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Server'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _serverNameController,
              decoration: InputDecoration(
                labelText: 'Server Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _serverConfigController,
              decoration: InputDecoration(
                labelText: 'Server Configuration (JSON) (v2ray only now)',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveServer,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}