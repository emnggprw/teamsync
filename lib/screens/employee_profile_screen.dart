import 'package:flutter/material.dart';
import 'package:teamsync/widgets/info_tile.dart';
import 'package:teamsync/models/employee.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final Employee employee;
  final VoidCallback? onSendMessage;
  final VoidCallback? onEditProfile;

  const EmployeeProfileScreen({
    required this.employee,
    this.onSendMessage,
    this.onEditProfile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLargeScreen = MediaQuery.of(context).size.width > 800;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: _buildAppBar(context, colorScheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileHeader(isLargeScreen, colorScheme),
                const SizedBox(height: 28),
                Divider(thickness: 2, color: colorScheme.outline.withOpacity(0.3)),
                const SizedBox(height: 28),
                _buildContactInfo(),
                const SizedBox(height: 36),
                _buildActionButtons(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
        tooltip: 'Back',
      ),
      actions: onEditProfile != null
          ? [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: onEditProfile,
          tooltip: 'Edit Profile',
        ),
      ]
          : null,
      elevation: 8,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }

  Widget _buildProfileHeader(bool isLargeScreen, ColorScheme colorScheme) {
    return Column(
      children: [
        Hero(
          tag: 'employee_avatar_${employee.name}',
          child: _buildAvatar(isLargeScreen, colorScheme),
        ),
        const SizedBox(height: 24),
        Text(
          employee.name,
          style: TextStyle(
            fontSize: isLargeScreen ? 30 : 26,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            employee.position,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(bool isLargeScreen, ColorScheme colorScheme) {
    final radius = isLargeScreen ? 90.0 : 70.0;

    if (employee.profileImageUrl != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(employee.profileImageUrl!),
        onBackgroundImageError: (_, __) {},
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
              width: 3,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        _getInitials(employee.name),
        style: TextStyle(
          fontSize: isLargeScreen ? 45 : 35,
          fontWeight: FontWeight.w800,
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        // Email - clickable
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _launchEmail(employee.email),
            child: InfoTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: employee.email,
            ),
          ),
        ),
        // Phone - clickable
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _launchPhone(employee.phone),
            child: InfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: employee.phone,
            ),
          ),
        ),
        // Address - clickable
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _launchMaps(employee.address),
            child: InfoTile(
              icon: Icons.location_on_outlined,
              title: 'Address',
              value: employee.address,
            ),
          ),
        ),
        // Department - not clickable
        InfoTile(
          icon: Icons.work_outline,
          title: 'Department',
          value: employee.department,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        if (onSendMessage != null)
          ElevatedButton.icon(
            onPressed: onSendMessage,
            icon: const Icon(Icons.message_outlined, size: 20),
            label: const Text(
              'Send Message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 4,
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => _showContactOptions(context),
          icon: const Icon(Icons.contact_phone_outlined, size: 20),
          label: const Text(
            'Contact',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(color: colorScheme.outline),
          ),
        ),
      ],
    );
  }

  void _launchEmail(String email) {
    // Implement email launching logic
    // Example: url_launcher package
    debugPrint('Launch email: $email');
  }

  void _launchPhone(String phone) {
    // Implement phone calling logic
    debugPrint('Launch phone: $phone');
  }

  void _launchMaps(String address) {
    // Implement maps launching logic
    debugPrint('Launch maps: $address');
  }

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Contact ${employee.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Send Email'),
              subtitle: Text(employee.email),
              onTap: () {
                Navigator.pop(context);
                _launchEmail(employee.email);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Call Phone'),
              subtitle: Text(employee.phone),
              onTap: () {
                Navigator.pop(context);
                _launchPhone(employee.phone);
              },
            ),
          ],
        ),
      ),
    );
  }
}