import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final VoidCallback onLogout;

  ProfilePage({required this.email, required this.onLogout, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('Email'),
                        subtitle: Text(email),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: onLogout,
                        child: Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}