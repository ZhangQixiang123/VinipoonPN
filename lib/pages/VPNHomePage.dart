import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  Map<String, Map<String, String>> _servers = {};
  // TextEditingController? _portController;
  // bool _globalProxy = false;

  @override
  void initState() {
    super.initState();
    _servers = {
      'Tokyo-Japan': {
        'flag': 'assets/flags/4x3/jp.svg',
        'config': '''{
          "address": "108.160.135.96",
          "port": 16823,
          "users": [
            {
              "id": "ddb70380-95b7-46fc-9b72-611f393ba418",
              "alterId": 0
            }
          ]
        }'''
      },
      'Los Angeles-USA': {
        'flag': 'assets/flags/4x3/us.svg',
        'config': '''{
          "address": "140.82.21.3",
          "port": 16823,
          "users": [
            {
              "id": "43aa28d1-0923-4db3-b8a1-4e4ad1d311f8",
              "alterId": 0
            }
          ]
        }'''
      },
      'Warsaw-Poland': {
        'flag': 'assets/flags/4x3/pl.svg',
        'config': '''{
          "address": "70.34.254.59",
          "port": 16823,
          "users": [
            {
              "id": "3d1ac968-19e8-4cfc-9053-764dd6c92416",
              "alterId": 0
            }
          ]
        }'''
      }
    };
    _selectedServer = _servers.keys.first;
    // _portController = TextEditingController();
    // _portController!.addListener(_onPortChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLang();
  }

  // @override
  // void dispose() {
  //   _portController?.removeListener(_onPortChanged);
  //   super.dispose();
  // }

  // void _onPortChanged() {
  //   setState(() {}); // Update the state to enable/disable the button based on port input
  // }

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
  }

  void _connectVPN() async {
    final config = await File('lib/Model/global.json').readAsString();
    // final config = _servers[_selectedServer]!['config']!;
    final configJson = jsonDecode(config);
    configJson['outbounds'][0]['settings']['vnext'][0] = jsonDecode(_servers[_selectedServer]!['config']!);
    final configTo = File('v2ray/config.json');
    await configTo.writeAsString(jsonEncode(configJson));

    Provider.of<VPNConnectionModel>(context, listen: false).setV2rayProcess(await Process.start('v2ray/v2ray', ['-config', configTo.path]));
    setState(() {
      Provider.of<VPNConnectionModel>(context, listen: false).setConnected(true);
    });

    if (Platform.isWindows) {
      final proxyUrl = '127.0.0.1:12800';
      final proxyOverride = 'localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*';
      final path = 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings';
      
      try {
        await Process.run('reg', ['add', path, '/v', 'ProxyServer', '/d', proxyUrl, '/f']);
        await Process.run('reg', ['add', path, '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '1', '/f']);
        await Process.run('reg', ['add', path, '/v', 'ProxyOverride', '/t', 'REG_SZ', '/d', proxyOverride, '/f']);
      } catch (e) {
        print('Failed to set proxy settings: $e');
      }
    }
  }

  void _disconnectVPN() async {
    if (Provider.of<VPNConnectionModel>(context, listen: false).v2rayProcess != null) {
      Provider.of<VPNConnectionModel>(context, listen: false).v2rayProcess!.kill();
      await Provider.of<VPNConnectionModel>(context, listen: false).v2rayProcess!.exitCode;
      setState(() {
        Provider.of<VPNConnectionModel>(context, listen: false).setConnected(false);
      });

      if (Platform.isWindows) {
        final path = 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings';

        try {
          await Process.run('reg', ['delete', path, '/v', 'ProxyServer', '/f']);
          await Process.run('reg', ['add', path, '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '0', '/f']);
          await Process.run('reg', ['delete', path, '/v', 'ProxyOverride', '/f']);
        } catch (e) {
          print('Failed to clear proxy settings: $e');
        }
      }
    }
  }

  void _changeSelectedServer(String? newServer) {
    setState(() {
      _selectedServer = newServer;
    });
  }

  // bool _isPortFilled() {
  //   return _portController!.text.isNotEmpty;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/common/guardian.png'),
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
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      _servers[key]!['flag']!,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 10),
                                    Text(key),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      // SizedBox(height: 20),
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 200,
                      //       child: TextField(
                      //         controller: _portController,
                      //         decoration: InputDecoration(
                      //           labelText: lang.str_listening_port,
                      //           border: OutlineInputBorder(),
                      //         ),
                      //         keyboardType: TextInputType.number,
                      //         enabled: !Provider.of<VPNConnectionModel>(context, listen: false).isConnected,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(height: 20),
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(lang.str_global_proxy),
                      //     Switch(
                      //       value: _globalProxy,
                      //       onChanged: (bool value) {
                      //         setState(() {
                      //           _globalProxy = value;
                      //         });
                      //       },
                      //     ),
                      //   ],
                      // ),
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
                              onPressed: _selectedServer == null //|| !_isPortFilled()
                                ? null 
                                : _connectVPN,
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

