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
      appBar: AppBar(
        title: Text('TeamSync Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: Icon(Icons.notifications_none, size: 28), onPressed: () {}),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.indigoAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () {
                setState(() => _selectedMenu = "Dashboard");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Employee List'),
              onTap: () {
                setState(() => _selectedMenu = "Employees");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Schedule'),
              onTap: () {
                setState(() => _selectedMenu = "Schedule");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildContent(),
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