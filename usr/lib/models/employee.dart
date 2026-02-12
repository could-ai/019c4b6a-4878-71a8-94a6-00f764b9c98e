class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String contractType;
  final DateTime hireDate;
  final double monthlySalary;
  final String status;
  final String? cnpsNumber;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.contractType,
    required this.hireDate,
    required this.monthlySalary,
    required this.status,
    this.cnpsNumber,
  });
}
