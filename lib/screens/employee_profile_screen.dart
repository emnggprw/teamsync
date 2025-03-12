import 'package:flutter/material.dart';
import 'package:teamsync/widgets/info_tile.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final String employeeName;

  const EmployeeProfileScreen({required this.employeeName, super.key});

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery
        .of(context)
        .size
        .width > 800;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 8,
        backgroundColor: Colors.indigo.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: isLargeScreen ? 90 : 70,
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(
                    employeeName[0],
                    style: TextStyle(
                      fontSize: isLargeScreen ? 70 : 50,
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  employeeName,
                  style: TextStyle(
                    fontSize: isLargeScreen ? 30 : 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Software Engineer',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.teal.shade600,
                  ),
                ),
                SizedBox(height: 28),
                Divider(thickness: 2, color: Colors.indigo.shade200),
                SizedBox(height: 28),
                InfoTile(icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'employee@example.com'),
                InfoTile(icon: Icons.phone_outlined,
                    title: 'Phone',
                    value: '+1 234 567 890'),
                InfoTile(icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: '123 Main Street, City'),
                InfoTile(icon: Icons.work_outline,
                    title: 'Department',
                    value: 'Technology'),
                SizedBox(height: 36),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.message_outlined, size: 22),
                  label: Text(
                    'Send Message',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    backgroundColor: Colors.indigo.shade700,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.tealAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}