import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import '../widgets/stat_card.dart';
import '../widgets/custom_appbar.dart';
import 'employee_search_screen.dart';
import 'schedule_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      drawer: !isLargeScreen ? SideMenu(onSelectMenu: _onMenuSelected) : null,
      body: Row(
        children: [
          if (isLargeScreen) SideMenu(onSelectMenu: _onMenuSelected),
          Expanded(child: _buildContent()),
        ],
      ),
      appBar: isLargeScreen
          ? null
          : CustomAppBar(onMenuTap: () => Scaffold.of(context).openDrawer()),
    );
  }

  void _onMenuSelected(String title) {
    setState(() => _selectedMenu = title);
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: _selectedMenu == "Employees"
            ? EmployeeSearchScreen()
            : _selectedMenu == "Schedule"
            ?  ScheduleScreen()
            : _buildDashboard(),
      ),
    );
  }

  Widget _buildDashboard() {
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ListTile(
            title: Text('Welcome to TeamSync!', style: Theme.of(context).textTheme.titleLarge),
            subtitle: Text(formattedDate),
            leading: Icon(Icons.dashboard, size: 40, color: Colors.indigo),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatCard(title: 'Employees', count: 12, icon: Icons.people, color: Colors.blue),
            StatCard(title: 'Schedules', count: 12, icon: Icons.schedule, color: Colors.green),
            StatCard(title: 'Pending Tasks', count: 12, icon: Icons.pending_actions, color: Colors.red),
          ],
        ),
      ],
    );
  }
}
