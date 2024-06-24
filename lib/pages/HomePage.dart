import 'package:flutter/material.dart';
import 'package:vinipoo_p_n/generated/l10n.dart';

import 'AboutPage.dart';
import 'SettingPage.dart';
import 'VPNHomePage.dart';

class HomePage extends StatefulWidget {
  final String email;
  HomePage({required this.email});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isHovering = false;

  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
  }


  @override
  Widget build(BuildContext context) {
    _updateLang();
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = VPNHomePage();
        break;
      case 1:
        page = SettingsPage(
          email: widget.email,
        );
        break;
      case 2:
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
                // color: Theme.of(context).colorScheme.primaryContainer,
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