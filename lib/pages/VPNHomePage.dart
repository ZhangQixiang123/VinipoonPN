import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';
import 'package:vinipoo_p_n/function/VPNConnection.dart';

import '../generated/l10n.dart';

class VPNHomePage extends StatefulWidget {
  VPNHomePage({Key? key}) : super(key: key);

  @override
  _VPNHomePageState createState() => _VPNHomePageState();
}

class _VPNHomePageState extends State<VPNHomePage> {
  
  @override
  void dispose() {
    super.dispose();
  }

  late S lang;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
      vpnModel.setServers(VPNConnection().servers);
      if (vpnModel.selectedServer == null) vpnModel.setSelectedServer(vpnModel.servers.keys.first);
    });
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
    final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
    Process process = await VPNConnection().connectVPN(vpnModel.selectedServer!, vpnModel.socksPort!, vpnModel.httpPort!);
    vpnModel.setV2rayProcess(process);
    vpnModel.setConnected(true);
    vpnModel.appendLog('Connected to ${vpnModel.selectedServer}');
    _startTrackingLogs(process);
  }

  void _addLog(String log) {
    Provider.of<VPNConnectionModel>(context, listen: false).appendLog(log);
  }

  Stream<String> _trackingLogs(Process process) async* {
    await for (final data in process.stdout.transform(utf8.decoder)) {
      yield data;
    }
  }

  void _startTrackingLogs(Process process) {
    _trackingLogs(process).listen((log) {
      _addLog(log.split('\n')[0]);
    });
  }

  void _disconnectVPN() async {
    final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
    VPNConnection().disconnectVPN();
    if (vpnModel.v2rayProcess != null) {
      vpnModel.v2rayProcess!.kill();
      await vpnModel.v2rayProcess!.exitCode;
      vpnModel.setConnected(false);
    }
    _addLog('Disconnected from ${vpnModel.selectedServer}');
  }

  void _changeSelectedServer(String? newServer) {
    Provider.of<VPNConnectionModel>(context, listen: false).setSelectedServer(newServer);
  }

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
                          Consumer<VPNConnectionModel>(
                            builder: (context, vpnModel, child) {
                              return DropdownButton<String>(
                                value: vpnModel.selectedServer,
                                onChanged: vpnModel.isConnected
                                    ? null
                                    : (String? newValue) {
                                        _changeSelectedServer(newValue);
                                      },
                                items: vpnModel.servers.keys
                                    .map<DropdownMenuItem<String>>((String key) {
                                  return DropdownMenuItem<String>(
                                    value: key,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          vpnModel.servers[key]!['flag']!,
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Text(key),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Consumer<VPNConnectionModel>(
                        builder: (context, vpnModel, child) {
                          return vpnModel.isConnected
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
                                  onPressed: vpnModel.selectedServer == null ? null : _connectVPN,
                                  icon: Icon(Icons.link),
                                  label: Text(lang.str_connect),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    textStyle: TextStyle(fontSize: 18),
                                  ),
                                );
                        },
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