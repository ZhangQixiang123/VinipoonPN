import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(VinipooPNApp());
}

class VinipooPNApp extends StatelessWidget {
  const VinipooPNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinipooPN',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: VPNHomePage(),
    );
  }
}

class VPNHomePage extends StatefulWidget {
  const VPNHomePage({super.key});

  @override
  _VPNHomePageState createState() => _VPNHomePageState();
}

class _VPNHomePageState extends State<VPNHomePage> {
  String _selectedServer = 'Tokyo-Japan';
  bool _isConnected = false;
  Process? _v2rayProcess;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VinipooPN'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              DropdownButton<String>(
                value: _selectedServer,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedServer = newValue!;
                  });
                },
                items: <String>['Tokyo-Japan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              _isConnected
                  ? ElevatedButton(
                      onPressed: _disconnectVPN,
                      child: Text('Disconnect'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    )
                  : ElevatedButton(
                      onPressed: _connectVPN,
                      child: Text('Connect'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
