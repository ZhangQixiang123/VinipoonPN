import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vinipoo_p_n/generated/l10n.dart';
import 'package:vinipoo_p_n/main.dart';

class LanguagePage extends StatefulWidget {
  LanguagePage({super.key});

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  void changeLang(Locale locale) {
    runApp(VinipooPNApp(locale));
  }

  @override
  Widget build(BuildContext context) {
    final lang = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.str_select_lang),
        backgroundColor: Color.fromARGB(214, 234, 221, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 20),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\gb.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('English', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('en'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\cn.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('中文（简体）', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('zh', 'CN'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\tw.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('中文（繁體）', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('zh', 'TW'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\jp.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('日本語', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('ja'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\kr.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('한국어', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('ko'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\de.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('Deutsch', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('de'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\fr.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('Français', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('fr'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\ru.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('Русский', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('ru'));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset(
                        'assets\\flags\\4x3\\es.svg',
                        width: 40,
                        height: 30,
                      ),
                      title: Text('Español', style: TextStyle(fontSize: 18)),
                      onTap: () {
                        changeLang(Locale('es'));
                      },
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
