import 'package:flutter/material.dart';

class ResponsiveDrawer extends StatelessWidget {
  final bool isCollapsed;
  ResponsiveDrawer({this.isCollapsed = true});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'TeamSync',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _drawerItem(icon: Icons.dashboard, text: 'Dashboard', onTap: () {}),
          _drawerItem(icon: Icons.people, text: 'Employees', onTap: () {}),
          _drawerItem(icon: Icons.schedule, text: 'Schedule', onTap: () {}),
          _drawerItem(icon: Icons.settings, text: 'Settings', onTap: () {}),
          Spacer(),
          _drawerItem(icon: Icons.logout, text: 'Logout', onTap: () {}),
        ],
      ),
    );
  }

  ListTile _drawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigoAccent),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
