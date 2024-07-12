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

  Process? get v2rayProcess => _v2rayProcess;
  bool get isConnected => _isConnected;
  List<String> get v2rayLog => _v2rayLog;
  Map<String, Map<String, String>> get servers => _servers;
  String? get selectedServer => _selectedServer;
  int? get socksPort => _socksPort;
  int? get httpPort => _httpPort;

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
}
