import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vinipoo_p_n/pages/HomePage.dart';
import 'generated/l10n.dart';
// import 'pages/LoginPage.dart';

void main() {
  var locale = Locale.fromSubtags(languageCode: 'en');
  runApp(VinipooPNApp(locale));
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
      home: HomePage(email: '',),
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
