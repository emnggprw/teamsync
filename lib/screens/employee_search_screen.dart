import 'package:flutter/material.dart';
import 'employee_profile_screen.dart';

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
