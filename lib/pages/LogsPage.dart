import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/Model/VPNConnectionModel.dart';
import 'package:vinipoo_p_n/generated/l10n.dart';

class LogsPage extends StatefulWidget {
  LogsPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => LogsPageState();
  
}

class LogsPageState extends State<LogsPage>{

  @override
  void dispose() {
    super.dispose();
  }

  late S lang;

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
  }
  
  @override
  Widget build(BuildContext context) {
    _updateLang();
    List<String> _logs = Provider.of<VPNConnectionModel>(context).v2rayLog;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            height: 600,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _logs[index],
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
