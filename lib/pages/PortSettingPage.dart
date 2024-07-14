import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vinipoo_p_n/generated/l10n.dart';
import '../Model/VPNConnectionModel.dart';

class PortSettingPage extends StatefulWidget {
  PortSettingPage({super.key});

  @override
  _PortSettingPageState createState() => _PortSettingPageState();
}

class _PortSettingPageState extends State<PortSettingPage> {
  late S lang;

  _updateLang() async {
    AppLocalizationDelegate delegate = const AppLocalizationDelegate();
    Locale myLocale = Localizations.localeOf(context);
    lang = await delegate.load(myLocale);
    setState(() {});
  }



  final TextEditingController _socksPortController = TextEditingController();
  final TextEditingController _httpPortController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
      _socksPortController.text = vpnModel.socksPort?.toString() ?? '';
      _httpPortController.text = vpnModel.httpPort?.toString() ?? '';
    });
  }

  String? _validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return lang.str_port_empty;
    }
    final int? port = int.tryParse(value);
    if (port == null) {
      return lang.str_port_valid;
    }
    if (port < 1024 || port > 65535) {
      return lang.str_port_range;
    }
    return null;
  }

  void _savePort() {
    if (_formKey.currentState!.validate()) {
      final vpnModel = Provider.of<VPNConnectionModel>(context, listen: false);
      int? socksPort = int.tryParse(_socksPortController.text);
      int? httpPort = int.tryParse(_httpPortController.text);
      
      vpnModel.setSocksPort(socksPort!);
      vpnModel.setHttpPort(httpPort!);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateLang();
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.str_listening_port),
        backgroundColor: Color.fromARGB(214, 234, 221, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _socksPortController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.str_socks_port_number,
                  border: OutlineInputBorder(),
                ),
                validator: _validatePort,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _httpPortController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.str_http_port_number,
                  border: OutlineInputBorder(),
                ),
                validator: _validatePort,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePort,
                child: Text(lang.str_save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
