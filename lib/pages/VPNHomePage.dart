import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';
import 'dart:io';

import '../generated/l10n.dart';

class VPNHomePage extends StatefulWidget {
  VPNHomePage({Key? key}) : super(key: key);

  @override
  _VPNHomePageState createState() => _VPNHomePageState();
}

class _VPNHomePageState extends State<VPNHomePage> {
  late S lang;

  String? _selectedServer;
  Map<String, String> _servers = {};

  @override
  void initState() {
    super.initState();
    
    _servers = {
      'Tokyo-Japan': '''{
        "inbounds": [
          {
            "port": 1279,
            "protocol": "socks",
            "sniffing": {
              "enabled": true,
              "destOverride": ["http", "tls"]
            },
            "settings": {
              "auth": "noauth"
            }
          }
        ],
        "outbounds": [
          {
            "protocol": "vmess",
            "settings": {
              "vnext": [
                {
                  "address": "108.160.135.96",
                  "port": 16823,
                  "users": [
                    {
                      "id": "ddb70380-95b7-46fc-9b72-611f393ba418",
                      "alterId": 0
                    }
                  ]
                }
              ]
            }
          }
        ]
      }''',
      'Server 2': '''{
        "log": {
          "loglevel": "warning"
        },
        "inbounds": [{
          "port": 1080,
          "listen": "127.0.0.1",
          "protocol": "socks",
          "settings": {
            "auth": "noauth",
            "udp": false
          }
        }],
        "outbounds": [{
          "protocol": "vmess",
          "settings": {
            "vnext": [{
              "address": "example2.com",
              "port": 443,
              "users": [{
                "id": "uuid-2",
                "alterId": 64
              }]
            }]
          },
          "streamSettings": {
            "network": "ws",
            "wsSettings": {
              "path": "/path2"
            },
            "security": "tls"
          }
        }]
      }''',
      'Server 3': '''{
        "log": {
          "loglevel": "warning"
        },
        "inbounds": [{
          "port": 1080,
          "listen": "127.0.0.1",
          "protocol": "socks",
          "settings": {
            "auth": "noauth",
            "udp": false
          }
        }],
        "outbounds": [{
          "protocol": "vmess",
          "settings": {
            "vnext": [{
              "address": "example3.com",
              "port": 443,
              "users": [{
                "id": "uuid-3",
                "alterId": 64
              }]
            }]
          },
          "streamSettings": {
            "network": "ws",
            "wsSettings": {
              "path": "/path3"
            },
            "security": "tls"
          }
        }]
      }'''
    };
    _selectedServer = _servers.keys.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLang();
  }

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
  }

  void _connectVPN() async {
    final config = _servers[_selectedServer]!;
    final configJson = jsonDecode(config);
    configJson['inbounds'][0]['port'] = int.parse(Provider.of<VPNConnectionModel>(context, listen: false).port.text);
    final configTo = File('v2ray/config.json');
    await configTo.writeAsString(jsonEncode(configJson));

    Provider.of<VPNConnectionModel>(context, listen: false).setV2rayProcess(await Process.start('v2ray/v2ray', ['-config', configTo.path]));
    setState(() {
      Provider.of<VPNConnectionModel>(context, listen: false).setConnected(true);
    });
  }

  void _disconnectVPN() async {
    if (Provider.of<VPNConnectionModel>(context, listen:  false).v2rayProcess != null) {
      Provider.of<VPNConnectionModel>(context, listen:  false).v2rayProcess!.kill();
      await Provider.of<VPNConnectionModel>(context, listen:  false).v2rayProcess!.exitCode;
      setState(() {
        Provider.of<VPNConnectionModel>(context, listen: false).setConnected(false);
      });
    }
  }

  void _changeSelectedServer(String? newServer) {
    setState(() {
      _selectedServer = newServer;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<VPNConnectionModel>(context, listen: false).isConnected);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(File('img/guardian.png')),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: _selectedServer,
                            onChanged: Provider.of<VPNConnectionModel>(context, listen: false).isConnected
                                ? null
                                : (String? newValue) {
                                    _changeSelectedServer(newValue);
                                  },
                            items: _servers.keys
                                .map<DropdownMenuItem<String>>((String key) {
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(key),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: Provider.of<VPNConnectionModel>(context, listen: false).port,
                              decoration: InputDecoration(
                                labelText: lang.str_enter_port,
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              enabled: !Provider.of<VPNConnectionModel>(context, listen: false).isConnected,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Provider.of<VPNConnectionModel>(context, listen: false).isConnected
                          ? ElevatedButton.icon(
                              onPressed: _disconnectVPN,
                              icon: Icon(Icons.link_off),
                              label: Text(lang.str_disconnect),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                textStyle: TextStyle(fontSize: 18),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _selectedServer == null ? null :  _connectVPN,

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
