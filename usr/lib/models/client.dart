class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String type;
  final String status;
  final bool taxExemption;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address = '',
    required this.type,
    required this.status,
    this.taxExemption = false,
  });
}
