import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final String selectedLanguage;

  const AboutPage({required this.selectedLanguage, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    selectedLanguage == 'English'
                        ? 'About VinipooPN'
                        : '关于VinipooPN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    selectedLanguage == 'English'
                        ? 'VinipooPN is a secure and reliable VPN service designed to protect your online privacy and ensure a fast and stable connection. Our servers are located around the globe, providing you with the best possible speeds and security.'
                        : 'VinipooPN是一项安全可靠的VPN服务，旨在保护您的在线隐私并确保快速稳定的连接。我们的服务器遍布全球，为您提供最佳的速度和安全性。',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}