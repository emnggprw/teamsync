import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(String) onSelectMenu;

  const SideMenu({required this.onSelectMenu, super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          _buildMenuItem(context, "Dashboard"),
          _buildMenuItem(context, "Employees"),
          _buildMenuItem(context, "Schedule"),
          _buildMenuItem(context, "Settings"),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      onTap: () => onSelectMenu(title),
    );
  }
}
