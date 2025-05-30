class Employee {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String department;
  final String position;
  final String? profileImageUrl;

  const Employee({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.department,
    required this.position,
    this.profileImageUrl,
  });
}