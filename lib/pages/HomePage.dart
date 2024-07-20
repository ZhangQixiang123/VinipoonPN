import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/function/VPNConnection.dart';
import 'package:vinipoo_p_n/generated/l10n.dart';
import 'package:vinipoo_p_n/pages/LogsPage.dart';
import 'package:vinipoo_p_n/pages/AboutPage.dart';
import 'package:vinipoo_p_n/pages/SettingsPage.dart';
import 'package:vinipoo_p_n/pages/VPNHomePage.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isHovering = false;

  late S lang;

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

  @override
  void initState() {
    super.initState();

    // Set up the window close listener
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      bool shouldClose = await _showCloseConfirmationDialog();
      return shouldClose;
    });
  }

  Future<bool> _showCloseConfirmationDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.str_close_window),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(lang.str_no),
          ),
          TextButton(
            onPressed: () async {
              final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
              await VPNConnection().disconnectVPN();
              if (vpnModel.v2rayProcess != null) {
                vpnModel.v2rayProcess!.kill();
                await vpnModel.v2rayProcess!.exitCode;
                vpnModel.setConnected(false);
              }
              Navigator.of(context).pop(true);
            },
            child: Text(lang.str_yes),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = VPNHomePage();
        break;
      case 1:
        page = LogsPage();
        break;
      case 2:
        page = SettingsPage();
        break;
      case 3:
        page = AboutPage();
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
                        label: Text(lang.str_home),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.assignment),
                        label: Text(lang.str_log),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text(lang.str_setting),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.info),
                        label: Text(lang.str_about),
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
                color: Color.fromARGB(214, 234, 221, 255),
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
