import 'package:flutter/material.dart';
import 'employee_profile_screen.dart';
import 'package:teamsync/models/employee.dart';

class EmployeeSearchScreen extends StatefulWidget {
  @override
  _EmployeeSearchScreenState createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Employee> employees = _generateSampleEmployees();
  final ValueNotifier<List<Employee>> _filteredEmployees = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _filteredEmployees.value = employees;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filteredEmployees.dispose();
    super.dispose();
  }

  static List<Employee> _generateSampleEmployees() {
    final departments = ['Technology', 'Marketing', 'Sales', 'HR', 'Finance'];
    final positions = [
      'Software Engineer',
      'Marketing Manager',
      'Sales Representative',
      'HR Specialist',
      'Financial Analyst',
      'Product Manager',
      'UI/UX Designer',
      'Data Scientist',
    ];

    return List.generate(12, (index) {
      final name = 'Employee ${index + 1}';
      final dept = departments[index % departments.length];
      final position = positions[index % positions.length];

      return Employee(
        name: name,
        email: '${name.toLowerCase().replaceAll(' ', '.')}@company.com',
        phone: '+1 ${(555 + index).toString().padLeft(3, '0')} ${(1000 + index * 11).toString().padLeft(4, '0')}',
        address: '${100 + index * 5} Main Street, City ${String.fromCharCode(65 + (index % 26))}',
        department: dept,
        position: position,
        // Simulate some employees having profile images
        profileImageUrl: index % 3 == 0 ? 'https://picsum.photos/200/200?random=$index' : null,
      );
    });
  }

  void _filterEmployees(String query) {
    if (query.isEmpty) {
      _filteredEmployees.value = employees;
      return;
    }

    _filteredEmployees.value = employees.where((employee) {
      final searchQuery = query.toLowerCase();
      return employee.name.toLowerCase().contains(searchQuery) ||
          employee.department.toLowerCase().contains(searchQuery) ||
          employee.position.toLowerCase().contains(searchQuery) ||
          employee.email.toLowerCase().contains(searchQuery);
    }).toList();
  }

  void _navigateToProfile(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmployeeProfileScreen(
          employee: employee,
          onSendMessage: () => _handleSendMessage(employee),
          onEditProfile: () => _handleEditProfile(employee),
        ),
      ),
    );
  }

  void _handleSendMessage(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${employee.name}...'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Implement your messaging logic here
  }

  void _handleEditProfile(Employee employee) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit profile for ${employee.name}'),
        duration: const Duration(seconds: 2),
      ),
    );
    // Implement your edit profile logic here
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 12),
          Expanded(child: _buildEmployeeList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Employee Directory',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ValueListenableBuilder<List<Employee>>(
          valueListenable: _filteredEmployees,
          builder: (context, employees, _) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${employees.length} found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search employees...',
        hintText: 'Name, department, position, or email',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _searchController.clear();
            _filterEmployees('');
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      onChanged: _filterEmployees,
    );
  }

  Widget _buildFilterChips() {
    final departments = employees.map((e) => e.department).toSet().toList();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: departments.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: const Text('All'),
                selected: _searchController.text.isEmpty,
                onSelected: (selected) {
                  if (selected) {
                    _searchController.clear();
                    _filterEmployees('');
                  }
                },
              ),
            );
          }

          final department = departments[index - 1];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(department),
              selected: false,
              onSelected: (selected) {
                if (selected) {
                  _searchController.text = department;
                  _filterEmployees(department);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeList() {
    return ValueListenableBuilder<List<Employee>>(
      valueListenable: _filteredEmployees,
      builder: (context, employees, _) {
        if (employees.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.separated(
          itemCount: employees.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return _EmployeeCard(
              employee: employees[index],
              onTap: () => _navigateToProfile(employees[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_search,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            "No employees found",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search terms",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const _EmployeeCard({
    required this.employee,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  String _getInitials(String name) {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names.first[0]}${names.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'employee_avatar_${employee.name}',
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: employee.profileImageUrl != null
                      ? NetworkImage(employee.profileImageUrl!)
                      : null,
                  child: employee.profileImageUrl == null
                      ? Text(
                    _getInitials(employee.name),
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.position,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      employee.department,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}