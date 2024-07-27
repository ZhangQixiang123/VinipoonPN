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
  late S lang;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
      if (vpnModel.isStart) {
        vpnModel.fetchServerInfo();
        vpnModel.setIsStart();
      }
      vpnModel.startPingUpdates();
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
    Process process = await VPNConnection().connectVPN(vpnModel);
    vpnModel.setV2rayProcess(process);
    vpnModel.setConnected(true);
    _addLog('Connected to ${vpnModel.selectedServer}');
    _startTrackingLogs(process, vpnModel);
  }

  void _addLog(String log) {
    final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
    if (mounted) {
      vpnModel.appendLog(log);
    }
  }

  Stream<String> _trackingLogs(Process process) async* {
    await for (final data in process.stdout.transform(utf8.decoder)) {
      yield data;
    }
  }

  void _startTrackingLogs(Process process, VPNConnectionModel vpnModel) {
    _trackingLogs(process).listen((log) {
      vpnModel.appendLog(log.split('\n')[0]);
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
    // _updatePingTime(newServer);
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
                      
                      Consumer<VPNConnectionModel>(
                        builder: (context, vpnModel, child) {
                          return Column(
                            children: [
                              ElevatedButton(
                                onPressed: vpnModel.isConnected ? null : (() {
                                  vpnModel.fetchServerInfo();
                                  vpnModel.startPingUpdates();
                                }),
                                child: Text(lang.str_update_server),
                              ),
                              SizedBox(height: 20),
                              DataTable(
                                columns: [
                                  DataColumn(label: Text(lang.str_server)),
                                  DataColumn(label: Text(lang.str_location)),
                                  DataColumn(label: Text(lang.str_ping_ms)),
                                  DataColumn(label: Text(lang.str_action)),
                                ],
                                rows: vpnModel.servers.keys.map((key) {
                                  final pingTime = vpnModel.getPingTime(key);
                                  return DataRow(cells: [
                                    DataCell(Text(key)),
                                    DataCell(SvgPicture.asset(
                                      vpnModel.servers[key]!['flag']!,
                                      width: 20,
                                      height: 20,
                                    )),
                                    DataCell(Text(pingTime != null ? '$pingTime' : 'N/A')),
                                    DataCell(
                                      vpnModel.selectedServer == key && vpnModel.isConnected
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
                                              onPressed: vpnModel.isConnected ? null : (vpnModel.selectedServer == key ? _connectVPN : () => _changeSelectedServer(key)),
                                              icon: vpnModel.selectedServer == key ? Icon(Icons.link) : Icon(Icons.arrow_forward),
                                              label: Text(vpnModel.selectedServer == key ? lang.str_connect : lang.str_select),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: vpnModel.selectedServer == key ? Colors.green : Colors.blue,
                                                textStyle: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                    ),
                                  ]);
                                }).toList(),
                              ),
                            ],
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
