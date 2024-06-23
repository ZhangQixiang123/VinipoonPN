import 'package:flutter/material.dart';

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
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = VPNHomePage();
        break;
      case 1:
        page = SettingsPage(
          email: widget.email,
          selectedLanguage: _selectedLanguage,
          onLanguageChanged: (newLanguage) {
            setState(() {
              _selectedLanguage = newLanguage;
            });
          },
        );
        break;
      case 2:
        page = AboutPage(selectedLanguage: _selectedLanguage);
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
                        label: Text(_selectedLanguage == 'English' ? 'Home' : '主页'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text(_selectedLanguage == 'English' ? 'Settings' : '设置'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.info),
                        label: Text(_selectedLanguage == 'English' ? 'About' : '关于我们'),
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
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}