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
// import 'pages/LoginPage.dart';

void main() {
  var locale = Locale.fromSubtags(languageCode: 'en');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VPNConnectionModel())
      ],
      child: VinipooPNApp(locale),
    ),
  );
}

class VinipooPNApp extends StatelessWidget {
  final Locale locale;

  const VinipooPNApp(this.locale, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinipooPN',
      // theme: ThemeData(
      //   primarySwatch: Colors.purple,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      home: LoginPage(),
      // home: HomePage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/language': (context) => LanguagePage(),
        '/settings': (context) => SettingsPage(),
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/profile': (context) => ProfilePage(),
        '/VPNhome': (context) => VPNHomePage()
      },
      localizationsDelegates: const [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const AppLocalizationDelegate().supportedLocales,
      locale: this.locale,
    );
  }
}
