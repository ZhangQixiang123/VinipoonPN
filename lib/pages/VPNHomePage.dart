import 'package:flutter/material.dart';
import 'dart:io';

import '../generated/l10n.dart';
import 'AddServerPage.dart';

class VPNHomePage extends StatefulWidget {
  const VPNHomePage({super.key});

  @override
  _VPNHomePageState createState() => _VPNHomePageState();
}

class _VPNHomePageState extends State<VPNHomePage> {
  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
  }
  
  String _selectedServer = '(None)';
  bool _isConnected = false;
  Process? _v2rayProcess;
  List<String> _servers = ['(None)'];

  void _connectVPN() async {
    final configFrom = File('server\\${_selectedServer}.json');
    String configInfo = await configFrom.readAsString();
    final configTo = File('v2ray\\config.json');
    await configTo.writeAsString(configInfo);

    _v2rayProcess = await Process.start('v2ray\\v2ray', ['-config', configTo.path]);

    setState(() {
      _isConnected = true;
    });
  }

  void _disconnectVPN() async {
    if (_v2rayProcess != null) {
      _v2rayProcess!.kill();
      await _v2rayProcess!.exitCode;
      setState(() {
        _isConnected = false;
      });
    }
  }

  void _addServer(String serverName, String serverConfig) async {
    if (_servers.contains(serverName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.str_server_exists)),
      );
      return;
    }

    setState(() {
      _servers.add(serverName);
      _selectedServer = serverName;
    });
    new File('server\\${_selectedServer}.json').create(recursive: true);
    final configTo = File('server\\${_selectedServer}.json');
    await configTo.writeAsString(serverConfig);
  }

  void _deleteServer(String serverName) async {
    setState(() {
      _servers.removeWhere((item) => item == serverName);
      _selectedServer = _servers[0];
    });
  }

  void _changeSelectedServer(String newServer) {
    setState(() {
      _selectedServer = newServer;
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateLang();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(new File('img\\guardian.png')),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        lang.str_select_server,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: _selectedServer,
                            onChanged: _isConnected
                                ? null
                                : (String? newValue) {
                                    _changeSelectedServer(newValue!);
                                  },
                            items: _servers
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Container(
                            child: TextButton(
                              child: Icon(Icons.add),
                              onPressed: _isConnected
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddServerPage(_addServer)),
                                      );
                                    },
                            ),
                          ),
                          Container(
                            child: TextButton(
                              child: Icon(Icons.delete),
                              onPressed: _selectedServer == '(None)' || _isConnected
                                  ? null
                                  : () {
                                      _deleteServer(_selectedServer);
                                    },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      _isConnected
                          ? ElevatedButton.icon(
                              onPressed:
                                  _selectedServer == '(None)' ? null : _disconnectVPN,
                              icon: Icon(Icons.link_off),
                              label: Text(lang.str_disconnect),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _selectedServer == '(None)' ? null : _connectVPN,
                              icon: Icon(Icons.link),
                              label: Text(lang.str_connect),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}