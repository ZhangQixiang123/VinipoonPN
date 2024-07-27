import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/foundation.dart';

class VPNConnectionModel extends ChangeNotifier {
  Process? _v2rayProcess;
  bool _isConnected = false;
  List<String> _v2rayLog = [];
  Map<String, Map<String, String>> _servers = {};
  String? _selectedServer;
  int? _socksPort = 12799;
  int? _httpPort = 12800;

  bool _isStart = true;
  bool get isStart => _isStart;
  void setIsStart() {
    _isStart = false;
  }

  Process? get v2rayProcess => _v2rayProcess;
  bool get isConnected => _isConnected;
  List<String> get v2rayLog => _v2rayLog;
  Map<String, Map<String, String>> get servers => _servers;
  String? get selectedServer => _selectedServer;
  int? get socksPort => _socksPort;
  int? get httpPort => _httpPort;

  Map<String, int?> _pingTimes = {};
  Timer? _pingTimer;

  void setV2rayProcess(Process process) {
    _v2rayProcess = process;
    notifyListeners();
  }

  void setConnected(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }

  void appendLog(String log) {
    _v2rayLog.add(log);
    notifyListeners();
  }

  void setServers(Map<String, Map<String, String>> servers) {
    _servers = servers;
    notifyListeners();
  }

  void setSelectedServer(String? server) {
    _selectedServer = server;
    notifyListeners();
  }

  void setSocksPort(int port) {
    _socksPort = port;
    notifyListeners();
  }

  void setHttpPort(int port) {
    _httpPort = port;
    notifyListeners();
  }
  
  void setPingTime(String server, int? ping) {
    _pingTimes[server] = ping;
    notifyListeners();
  }

  int? getPingTime(String server) {
    return _pingTimes[server];
  }

  String to_address(String server) {
      return (servers[server]?['address'])!;
  }

  Future<void> updatePingTime(String server) async {
  final address = to_address(server);
  final process = await Process.start(
    'ping/dist/Ping.exe',
    [address],
  );

  final output = await process.stdout.transform(utf8.decoder).join();

  if(output != -1) {
    setPingTime(server, int.parse(output));
  } else {
    setPingTime(server, null);
  }

  print(output);
}

  void startPingUpdates() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 2), (_) {
      _servers.keys.forEach((server) {
        updatePingTime(server);
      });
    });
  }

  void stopPingUpdates() {
    _pingTimer?.cancel();
  }

  Future<void> fetchServerInfo() async {
    print("OK");
    stopPingUpdates();
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/vpnconfig/api/all/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        final servers = <String, Map<String, String>>{};
        for (var item in data) {
          servers[item['name']] = {
            'address': item['ip_address'],
            'port': item['port'].toString(),
            'id': item['userid'],
            'flag': 'assets/flags/4x3/${item['country_code']}.svg',
          };
        }
        setServers(servers);
      } else {
        throw Exception('Failed to load server info');
      }
    } catch (e) {
      print(e);
    }
  }
}
