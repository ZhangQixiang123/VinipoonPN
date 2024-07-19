import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';
import 'package:vinipoo_p_n/function/VPNConnection.dart';
import 'package:vinipoo_p_n/pages/AboutPage.dart';
import 'package:vinipoo_p_n/pages/HomePage.dart';
import 'package:vinipoo_p_n/pages/LanguagePage.dart';
import 'package:vinipoo_p_n/pages/LoginPage.dart';
import 'package:vinipoo_p_n/pages/ProfilePage.dart';
import 'package:vinipoo_p_n/pages/SettingsPage.dart';
import 'package:vinipoo_p_n/pages/SignUpPage.dart';
import 'package:vinipoo_p_n/pages/VPNHomePage.dart';
import 'generated/l10n.dart';

void main() {
  var locale = Locale.fromSubtags(languageCode: 'en');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VPNConnectionModel()),
      ],
      child: VinipooPNApp(locale),
    ),
  );
}

class VinipooPNApp extends StatelessWidget {
  final Locale locale;

  const VinipooPNApp(this.locale, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinipooPN',
      home: MyApp(locale: locale),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/language': (context) => LanguagePage(),
        '/settings': (context) => SettingsPage(),
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/profile': (context) => ProfilePage(),
        '/VPNhome': (context) => VPNHomePage(),
      },
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizationDelegate().supportedLocales,
      locale: locale,
    );
  }
}

class MyApp extends StatefulWidget {
  final Locale locale;

  const MyApp({required this.locale, Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        title: Text('Are you sure you want to close the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
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
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
