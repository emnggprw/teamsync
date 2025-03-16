import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingsOption(
            context,
            title: 'Dark Mode',
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            title: 'Notifications',
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Notifications Settings
            },
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            title: 'Account',
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Account Settings
            },
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            title: 'Privacy & Security',
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to Privacy Settings
            },
          ),
          const Divider(),
          _buildSettingsOption(
            context,
            title: 'Help & Support',
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              const url = 'https://github.com/emnggprw/teamsync';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }
            },
          ),

        ],
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, {
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
