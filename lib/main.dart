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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isHovering = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = VPNHomePage();
        break;
      case 1:
        page = SettingsPage(
          selectedLanguage: _selectedLanguage,
          onLanguageChanged: (newLanguage) {
            setState(() {
              _selectedLanguage = newLanguage;
            });
          },
        );
        break;
      case 2:
        page = AboutPage(selectedLanguage: _selectedLanguage);
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600 && _isHovering,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text(_selectedLanguage == 'English' ? 'Home' : '主页'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text(_selectedLanguage == 'English' ? 'Settings' : '设置'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.info),
                        label: Text(_selectedLanguage == 'English' ? 'About' : '关于我们'),
                      ),
                    ],
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        _selectedIndex = value;
                        _isHovering = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class VPNHomePage extends StatefulWidget {
  const VPNHomePage({super.key});

  @override
  _VPNHomePageState createState() => _VPNHomePageState();
}

class _VPNHomePageState extends State<VPNHomePage> {
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
        SnackBar(content: Text('Server name already exists!')),
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
    return Padding(
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
                    'Select VPN Server',
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
                          label: Text('Disconnect'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _selectedServer == '(None)' ? null : _connectVPN,
                          icon: Icon(Icons.link),
                          label: Text('Connect'),
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
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  SettingsPage({required this.selectedLanguage, required this.onLanguageChanged, super.key});

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
                  leading: Icon(Icons.security),
                  title: Text(selectedLanguage == 'English' ? 'Security' : '安全'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle security setting
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(selectedLanguage == 'English' ? 'Notifications' : '通知'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Handle notifications setting
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

class AboutPage extends StatelessWidget {
  final String selectedLanguage;

  const AboutPage({required this.selectedLanguage, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    selectedLanguage == 'English'
                        ? 'About VinipooPN'
                        : '关于VinipooPN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    selectedLanguage == 'English'
                        ? 'VinipooPN is a secure and reliable VPN service designed to protect your online privacy and ensure a fast and stable connection. Our servers are located around the globe, providing you with the best possible speeds and security.'
                        : 'VinipooPN是一项安全可靠的VPN服务，旨在保护您的在线隐私并确保快速稳定的连接。我们的服务器遍布全球，为您提供最佳的速度和安全性。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
