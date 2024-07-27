import 'dart:convert';
import 'dart:io';

import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';   

class VPNConnection {

  Map<String, Map<String, String>> servers = {
      'Tokyo-Japan': {
        'flag': 'assets/flags/4x3/jp.svg',
        "address": "2001:19f0:7002:0f91:5400:05ff:fe08:ab85",
        "port": "16823",
        "id": "3740759a-870a-457c-9441-5401d2e8446f",
      },
      'Sydney-Australia': {
        'flag': 'assets/flags/4x3/au.svg',
        "address": "2001:19f0:5801:0c2a:5400:05ff:fe08:a9cc",
        "port": "16823",
        "id": "43aa28d1-0923-4db3-b8a1-4e4ad1d311f8",
      },
      'Warsaw-Poland': {
        'flag': 'assets/flags/4x3/pl.svg',
        "address": "70.34.254.59",
        "port": "16823",
        "id": "3d1ac968-19e8-4cfc-9053-764dd6c92416",
      }
    };


  Future<Process> connectVPN(VPNConnectionModel vpnModel) async {
    final config = await File('model/global.json').readAsString();
    final configJson = jsonDecode(config);
    configJson['outbounds'][0]['settings']['vnext'][0]['address'] = vpnModel.servers[vpnModel.selectedServer]?['address'];
    configJson['outbounds'][0]['settings']['vnext'][0]['port'] = int.parse((vpnModel.servers[vpnModel.selectedServer]?['port'])!);
    configJson['outbounds'][0]['settings']['vnext'][0]['users'][0]['id'] = vpnModel.servers[vpnModel.selectedServer]?['id'];
    configJson['inbounds'][0]['port'] = vpnModel.socksPort;
    configJson['inbounds'][1]['port'] = vpnModel.httpPort;
    final configTo = File('v2ray/config.json');
    await configTo.writeAsString(jsonEncode(configJson));

    int port = vpnModel.httpPort!;

    if (Platform.isWindows) {
      final proxyUrl = '127.0.0.1:$port';
      final proxyOverride = 'localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*';
      final path = 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings';
      
      try {
        Process.run('reg', ['add', path, '/v', 'ProxyServer', '/d', proxyUrl, '/f']);
        Process.run('reg', ['add', path, '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '1', '/f']);
        Process.run('reg', ['add', path, '/v', 'ProxyOverride', '/t', 'REG_SZ', '/d', proxyOverride, '/f']);
      } catch (e) {
        print('Failed to set proxy settings: $e');
      }
    }

    return Process.start('v2ray/v2ray', ['-config', configTo.path]);
  }

  Future<bool> disconnectVPN() async {
      if (Platform.isWindows) {
        final path = 'HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings';

        try {
          Process.run('reg', ['add', path, '/v', 'ProxyEnable', '/t', 'REG_DWORD', '/d', '0', '/f']);
          Process.run('reg', ['delete', path, '/v', 'ProxyOverride', '/f']);
          Process.run('reg', ['delete', path, '/v', 'ProxyServer', '/f']);
          return true;
        } catch (e) {
          print('Failed to clear proxy settings: $e');
        }
      }

      return false;
  }
  
}