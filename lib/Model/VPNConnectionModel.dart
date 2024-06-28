import 'dart:io';

import 'package:flutter/material.dart';

class VPNConnectionModel extends ChangeNotifier {
  
  Process? _v2rayProcess;
  Process? get v2rayProcess => _v2rayProcess;
  
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  TextEditingController _port = TextEditingController();
  TextEditingController get port => _port;

  void setV2rayProcess(Process v2rayProcess) {
    _v2rayProcess = v2rayProcess;
    notifyListeners();
  }

  void setConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  void setPort(TextEditingController port) {
    _port = port;
    notifyListeners();
  }
  
}
