import 'package:flutter/material.dart';
import 'pages/LoginPage.dart';

void main() {
  runApp(VinipooPNApp());
}

class VinipooPNApp extends StatelessWidget {
  const VinipooPNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VinipooPN',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}