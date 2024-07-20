import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';
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

  late S lang;
  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLang();
  }

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}
