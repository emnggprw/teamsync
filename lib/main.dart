import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(TeamSyncApp());
}

class TeamSyncApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeamSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[200],
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedMenu = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationPanel(
            selectedMenu: _selectedMenu,
            onMenuSelected: (menu) => setState(() => _selectedMenu = menu),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedMenu) {
      case "Employees":
        return EmployeeSearchScreen();
      case "Schedule":
        return ScheduleScreen();
      default:
        return Center(
          child: Text('Welcome to TeamSync', style: Theme.of(context).textTheme.titleLarge),
        );
    }
  }
}

class NavigationPanel extends StatelessWidget {
  final String selectedMenu;
  final Function(String) onMenuSelected;

  NavigationPanel({required this.selectedMenu, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.indigo,
      child: Column(
        children: [
          DrawerHeader(
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: Text('Dashboard', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuSelected("Dashboard"),
          ),
          ListTile(
            title: Text('Employee List', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuSelected("Employees"),
          ),
          ListTile(
            title: Text('Schedule', style: TextStyle(color: Colors.white)),
            onTap: () => onMenuSelected("Schedule"),
          ),
        ],
      ),
    );
  }
}

class EmployeeSearchScreen extends StatefulWidget {
  @override
  _EmployeeSearchScreenState createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> employees = List.generate(12, (index) => 'Employee ${index + 1}');
  List<String> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    filteredEmployees = employees;
  }

  void _filterEmployees(String query) {
    setState(() {
      filteredEmployees = employees
          .where((employee) => employee.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee List', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 10),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Employee',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: _filterEmployees,
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEmployees.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredEmployees[index]),
                  leading: CircleAvatar(child: Text(filteredEmployees[index].split(' ')[1])),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Schedule', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 10),
          Expanded(
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
            ),
          ),
        ],
      ),
    );
  }
}