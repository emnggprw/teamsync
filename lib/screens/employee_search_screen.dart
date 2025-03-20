import 'package:flutter/material.dart';
import 'employee_profile_screen.dart';

class EmployeeSearchScreen extends StatefulWidget {
  @override
  _EmployeeSearchScreenState createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> employees = List.generate(12, (index) => 'Employee ${index + 1}');
  final ValueNotifier<List<String>> _filteredEmployees = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _filteredEmployees.value = employees;
  }

  void _filterEmployees(String query) {
    _filteredEmployees.value = employees
        .where((employee) => employee.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _navigateToProfile(String employeeName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeProfileScreen(employeeName: employeeName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee List', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 12),
          Expanded(child: _buildEmployeeList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search Employee',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: _filterEmployees,
    );
  }

  Widget _buildEmployeeList() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _filteredEmployees,
      builder: (context, employees, _) {
        if (employees.isEmpty) {
          return const Center(child: Text("No employees found", style: TextStyle(fontSize: 16)));
        }
        return ListView.separated(
          itemCount: employees.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _EmployeeCard(
              employeeName: employees[index],
              onTap: () => _navigateToProfile(employees[index]),
            );
          },
        );
      },
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final String employeeName;
  final VoidCallback onTap;

  const _EmployeeCard({required this.employeeName, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Text(employeeName[0]),
        ),
        title: Text(
          employeeName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
