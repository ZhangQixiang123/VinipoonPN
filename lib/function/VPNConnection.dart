
import 'dart:convert';
import 'dart:io';

class VPNConnection {
  Map<String, Map<String, String>> servers = {
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

  Future<Process> connectVPN(String _selectedServer, int socksPort, int httpPort) async {
    final config = await File('assets/model/global.json').readAsString();
    // final config = _servers[_selectedServer]!['config']!;
    final configJson = jsonDecode(config);
    configJson['outbounds'][0]['settings']['vnext'][0] = jsonDecode(servers[_selectedServer]!['config']!);
    configJson['inbounds'][0]['port'] = socksPort;
    configJson['inbounds'][1]['port'] = httpPort;
    final configTo = File('v2ray/config.json');
    await configTo.writeAsString(jsonEncode(configJson));

    if (Platform.isWindows) {
      final proxyUrl = '127.0.0.1:$httpPort';
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

    return Process.start('v2ray/v2ray', ['-config', configTo.path]);
  }

  void disconnectVPN() async {
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