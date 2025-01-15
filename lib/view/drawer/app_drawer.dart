import 'package:flutter/material.dart';
import 'package:futurgen_attendance/view/drawer/profile.dart';
import 'package:futurgen_attendance/view/drawer/settings.dart';

import 'about_us.dart';
import 'logout.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 100),
        DrawerMenuItem(
          icon: Icons.home,
          title: 'Home',
          onTap: () {
            Navigator.pop(context);
          },
        ),
        Divider(),
        DrawerMenuItem(
          icon: Icons.account_circle,
          title: 'Profile',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        Divider(),
        DrawerMenuItem(
          icon: Icons.info,
          title: 'About Us',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutUsScreen()),
            );
          },
        ),
        Divider(),
        DrawerMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Settings()),
            );
          },
        ),
        Divider(),
        DrawerMenuItem(
          icon: Icons.exit_to_app,
          title: 'Log Out',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> LogoutScreen()),
            );
          },
        ),
        Divider(),
      ],
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
