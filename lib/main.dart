import 'package:flutter/material.dart';

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

class DashboardScreen extends StatelessWidget {
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
      drawer: ResponsiveDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth >= 800;
          return Row(
            children: [
              if (isWideScreen) Expanded(flex: 2, child: ResponsiveDrawer(isCollapsed: false)),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employee List', style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: 10),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isWideScreen ? 3 : 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 3.5,
                          ),
                          itemCount: 12,
                          itemBuilder: (context, index) {
                            return EmployeeCard(index: index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ResponsiveDrawer extends StatelessWidget {
  final bool isCollapsed;
  ResponsiveDrawer({this.isCollapsed = true});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text('TeamSync',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ),
          _drawerItem(icon: Icons.dashboard, text: 'Dashboard', onTap: () {}),
          _drawerItem(icon: Icons.people, text: 'Employees', onTap: () {}),
          _drawerItem(icon: Icons.schedule, text: 'Schedule', onTap: () {}),
          _drawerItem(icon: Icons.settings, text: 'Settings', onTap: () {}),
          Spacer(),
          _drawerItem(icon: Icons.logout, text: 'Logout', onTap: () {}),
        ],
      ),
    );
  }

  ListTile _drawerItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigoAccent),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final int index;
  EmployeeCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.indigoAccent,
              child: Text('E${index + 1}',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Employee ${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
                  SizedBox(height: 4),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Position: Manager',
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
