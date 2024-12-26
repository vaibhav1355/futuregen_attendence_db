import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Center(
          child: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blueAccent),
            title: Text('Enable Notifications'),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.blueAccent),
            title: Text('Enable Dark Mode'),
            trailing: Switch(
              value: darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  darkModeEnabled = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person, color: Colors.blueAccent),
            title: Text('Account'),
            onTap: () {

            },
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.blueAccent),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy screen
            },
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blueAccent),
            title: Text('About Us'),
            onTap: () {
              // Add About Us navigation logic here
            },
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.support, color: Colors.blueAccent),
            title: Text('Contact Support'),
            onTap: () {

            },
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              '© 2024 FutureGen Solutions',
              style: TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
