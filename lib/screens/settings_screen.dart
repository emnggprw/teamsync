import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildThemeOption(context),
          const Divider(),
          _buildNavigationOption(
            context,
            title: 'Notifications',
            onTap: () => _navigateToNotifications(context),
          ),
          const Divider(),
          _buildNavigationOption(
            context,
            title: 'Account',
            onTap: () => _navigateToAccount(context),
          ),
          const Divider(),
          _buildNavigationOption(
            context,
            title: 'Privacy & Security',
            onTap: () => _navigateToPrivacy(context),
          ),
          const Divider(),
          _buildNavigationOption(
            context,
            title: 'Help & Support',
            onTap: () => _launchHelpUrl(context),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          title: const Text('Dark Mode'),
          trailing: Switch(
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: themeProvider.toggleTheme,
          ),
        );
      },
    );
  }

  Widget _buildNavigationOption(
      BuildContext context, {
        required String title,
        required VoidCallback onTap,
      }) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _navigateToNotifications(BuildContext context) {
    // Navigate to Notifications Settings
    // Navigator.pushNamed(context, '/notifications');
  }

  void _navigateToAccount(BuildContext context) {
    // Navigate to Account Settings
    // Navigator.pushNamed(context, '/account');
  }

  void _navigateToPrivacy(BuildContext context) {
    // Navigate to Privacy Settings
    // Navigator.pushNamed(context, '/privacy');
  }

  Future<void> _launchHelpUrl(BuildContext context) async {
    const url = 'https://github.com/emnggprw/teamsync';
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showUrlError(context, url);
      }
    } catch (e) {
      _showUrlError(context, url);
    }
  }

  void _showUrlError(BuildContext context, String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not open $url'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}