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
            _buildStatCard('Employees', totalEmployees, Icons.people, Colors.blue),
            _buildStatCard('Schedules', upcomingSchedules, Icons.schedule, Colors.green),
            _buildStatCard('Pending Tasks', pendingTasks, Icons.pending_actions, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        shadowColor: color.withOpacity(0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 40, color: color),
              ),
              SizedBox(height: 15),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
              SizedBox(height: 8),
              Text(count.toString(), style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color)),
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
              return GestureDetector(
                onTap: () => _navigateToProfile(filteredEmployees[index]),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: Text(filteredEmployees[index][0]),
                    ),
                    title: Text(
                      filteredEmployees[index],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
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
  const EmployeeProfileScreen({required this.employeeName, super.key});

  @override
  Widget build(BuildContext context) {
    bool isLargeScreen = MediaQuery.of(context).size.width > 800;

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
                _buildInfoTile(Icons.email_outlined, 'Email', 'employee@example.com'),
                _buildInfoTile(Icons.phone_outlined, 'Phone', '+1 234 567 890'),
                _buildInfoTile(Icons.location_on_outlined, 'Address', '123 Main Street, City'),
                _buildInfoTile(Icons.work_outline, 'Department', 'Technology'),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.teal.shade700, size: 26),
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo.shade900),
                ),
                SizedBox(height: 6),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
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
