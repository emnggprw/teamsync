import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalEmployees = 12;
  int upcomingSchedules = 5;
  int pendingTasks = 3;

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      key: _scaffoldKey,
      drawer: !isLargeScreen ? Drawer(child: _buildSideMenu()) : null,
      body: Row(
        children: [
          if (isLargeScreen)
            SizedBox(
              width: 250,
              child: _buildSideMenu(),
            ),
          Expanded(child: _buildContent(isLargeScreen)),
        ],
      ),
      appBar: isLargeScreen
          ? null
          : AppBar(
        title: Text("TeamSync"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
    );
  }

  Widget _buildSideMenu() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade900, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            _buildMenuItem("Dashboard"),
            _buildMenuItem("Employees"),
            _buildMenuItem("Schedule"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
      hoverColor: Colors.white24,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        setState(() => _selectedMenu = title);
        if (MediaQuery.of(context).size.width < 800) Navigator.pop(context);
      },
    );
  }

  Widget _buildContent(bool isLargeScreen) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: _selectedMenu == "Employees"
            ? EmployeeSearchScreen()
            : _selectedMenu == "Schedule"
            ? ScheduleScreen()
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
            _buildStatCard('Employees', totalEmployees, Icons.people),
            _buildStatCard('Schedules', upcomingSchedules, Icons.schedule),
            _buildStatCard('Pending Tasks', pendingTasks, Icons.pending_actions),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.indigo),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(count.toString(), style: TextStyle(fontSize: 24, color: Colors.indigo)),
            ],
          ),
        ),
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

  void _navigateToProfile(String employeeName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeProfileScreen(employeeName: employeeName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                onTap: () => _navigateToProfile(filteredEmployees[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EmployeeProfileScreen extends StatelessWidget {
  final String employeeName;
  const EmployeeProfileScreen({required this.employeeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(employeeName)),
      body: Center(child: Text('Profile of $employeeName')),
    );
  }
}


class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
