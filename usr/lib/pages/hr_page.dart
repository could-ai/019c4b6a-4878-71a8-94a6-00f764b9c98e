import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/employee.dart';

class HrPage extends StatefulWidget {
  const HrPage({super.key});

  @override
  State<HrPage> createState() => _HrPageState();
}

class _HrPageState extends State<HrPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Employee> employees = [
    Employee(
      id: '1',
      firstName: 'Jean',
      lastName: 'Dupont',
      email: 'jean.dupont@entreprise.com',
      phone: '+225 01 02 03 04',
      position: 'Développeur',
      department: 'Informatique',
      contractType: 'CDI',
      hireDate: DateTime(2023, 1, 15),
      monthlySalary: 500000,
      status: 'Actif',
      cnpsNumber: 'CNPS123456',
    ),
    Employee(
      id: '2',
      firstName: 'Marie',
      lastName: 'Koné',
      email: 'marie.kone@entreprise.com',
      phone: '+225 05 06 07 08',
      position: 'Comptable',
      department: 'Finance',
      contractType: 'CDI',
      hireDate: DateTime(2022, 6, 1),
      monthlySalary: 450000,
      status: 'Actif',
      cnpsNumber: 'CNPS789012',
    ),
  ];

  List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      id: '1',
      employeeId: '1',
      employeeName: 'Jean Dupont',
      type: 'Congés annuels',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 37)),
      status: 'En attente',
      reason: 'Vacances familiales',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Ressources Humaines",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEmployeeDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Nouvel Employé"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Employés'),
              Tab(text: 'Congés'),
              Tab(text: 'Paie'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmployeesTab(),
                _buildLeavesTab(),
                _buildPayrollTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeesTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                  columns: const [
                    DataColumn(label: Text('Nom')),
                    DataColumn(label: Text('Poste')),
                    DataColumn(label: Text('Département')),
                    DataColumn(label: Text('Statut')),
                    DataColumn(label: Text('Salaire')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: employees.map((employee) => _buildEmployeeRow(employee)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeavesTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Demandes de Congés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddLeaveDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle Demande'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: leaveRequests.length,
                itemBuilder: (context, index) {
                  final leave = leaveRequests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('${leave.employeeName} - ${leave.type}'),
                      subtitle: Text('${leave.startDate.day}/${leave.startDate.month} - ${leave.endDate.day}/${leave.endDate.month} • ${leave.status}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leave.status == 'En attente')
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approveLeave(leave),
                            ),
                          if (leave.status == 'En attente')
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _rejectLeave(leave),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayrollTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Génération des Bulletins de Paie', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('${employee.firstName} ${employee.lastName}'),
                      subtitle: Text('${employee.position} • ${employee.monthlySalary} XOF/mois'),
                      trailing: ElevatedButton(
                        onPressed: () => _generatePayroll(employee),
                        child: const Text('Générer Bulletin'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildEmployeeRow(Employee employee) {
    return DataRow(cells: [
      DataCell(Text('${employee.firstName} ${employee.lastName}', style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(employee.position)),
      DataCell(Text(employee.department)),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: employee.status == 'Actif' ? Colors.green[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            employee.status,
            style: TextStyle(
              color: employee.status == 'Actif' ? Colors.green[800] : Colors.grey[800],
              fontSize: 12,
            ),
          ),
        ),
      ),
      DataCell(Text('${employee.monthlySalary} XOF')),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditEmployeeDialog(employee),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _deleteEmployee(employee),
          ),
          IconButton(
            icon: const Icon(Icons.description, size: 20),
            onPressed: () => _viewEmployeeDetails(employee),
          ),
        ],
      )),
    ]);
  }

  void _showAddEmployeeDialog() {
    showDialog(
      context: context,
      builder: (context) => const EmployeeFormDialog(),
    ).then((newEmployee) {
      if (newEmployee != null) {
        setState(() {
          employees.add(newEmployee);
        });
      }
    });
  }

  void _showEditEmployeeDialog(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => EmployeeFormDialog(employee: employee),
    ).then((updatedEmployee) {
      if (updatedEmployee != null) {
        setState(() {
          final index = employees.indexWhere((e) => e.id == employee.id);
          if (index != -1) {
            employees[index] = updatedEmployee;
          }
        });
      }
    });
  }

  void _deleteEmployee(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${employee.firstName} ${employee.lastName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                employees.removeWhere((e) => e.id == employee.id);
              });
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _viewEmployeeDetails(Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de ${employee.firstName} ${employee.lastName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${employee.email}'),
              Text('Téléphone: ${employee.phone}'),
              Text('Poste: ${employee.position}'),
              Text('Département: ${employee.department}'),
              Text('Type de contrat: ${employee.contractType}'),
              Text('Date d\'embauche: ${employee.hireDate.day}/${employee.hireDate.month}/${employee.hireDate.year}'),
              Text('Salaire mensuel: ${employee.monthlySalary} XOF'),
              Text('Statut: ${employee.status}'),
              if (employee.cnpsNumber != null) Text('CNPS: ${employee.cnpsNumber}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAddLeaveDialog() {
    showDialog(
      context: context,
      builder: (context) => LeaveRequestFormDialog(employees: employees),
    ).then((newLeave) {
      if (newLeave != null) {
        setState(() {
          leaveRequests.add(newLeave);
        });
      }
    });
  }

  void _approveLeave(LeaveRequest leave) {
    setState(() {
      final index = leaveRequests.indexWhere((l) => l.id == leave.id);
      if (index != -1) {
        leaveRequests[index] = leaveRequests[index].copyWith(status: 'Approuvé');
      }
    });
  }

  void _rejectLeave(LeaveRequest leave) {
    setState(() {
      final index = leaveRequests.indexWhere((l) => l.id == leave.id);
      if (index != -1) {
        leaveRequests[index] = leaveRequests[index].copyWith(status: 'Refusé');
      }
    });
  }

  void _generatePayroll(Employee employee) {
    // Simplified payroll calculation
    final grossSalary = employee.monthlySalary;
    final cnpsContribution = grossSalary * 0.063; // 6.3% CNPS
    final ipresContribution = grossSalary * 0.045; // 4.5% IPRES (simplified)
    final taxBase = grossSalary - cnpsContribution - ipresContribution;
    final incomeTax = _calculateIncomeTax(taxBase);
    final netSalary = taxBase - incomeTax;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulletin de Paie - ${employee.firstName} ${employee.lastName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Salaire brut: ${grossSalary.toStringAsFixed(0)} XOF'),
              Text('Cotisation CNPS (6.3%): ${cnpsContribution.toStringAsFixed(0)} XOF'),
              Text('Cotisation IPRES (4.5%): ${ipresContribution.toStringAsFixed(0)} XOF'),
              Text('Base imposable: ${taxBase.toStringAsFixed(0)} XOF'),
              Text('Impôt sur le revenu: ${incomeTax.toStringAsFixed(0)} XOF'),
              const Divider(),
              Text('Salaire net: ${netSalary.toStringAsFixed(0)} XOF', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Imprimer'),
          ),
        ],
      ),
    );
  }

  double _calculateIncomeTax(double taxBase) {
    // Simplified progressive tax calculation (Côte d'Ivoire)
    if (taxBase <= 50000) return 0;
    if (taxBase <= 200000) return (taxBase - 50000) * 0.015;
    if (taxBase <= 500000) return 7500 + (taxBase - 200000) * 0.025;
    return 7500 + 7500 + (taxBase - 500000) * 0.035;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class EmployeeFormDialog extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormDialog({super.key, this.employee});

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _positionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _salaryController = TextEditingController();
  final _cnpsController = TextEditingController();
  String _contractType = 'CDI';
  String _status = 'Actif';
  DateTime _hireDate = DateTime.now();

  final List<String> contractTypes = ['CDI', 'CDD', 'Freelance', 'Stage'];
  final List<String> statuses = ['Actif', 'Suspendu', 'Parti'];

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _firstNameController.text = widget.employee!.firstName;
      _lastNameController.text = widget.employee!.lastName;
      _emailController.text = widget.employee!.email;
      _phoneController.text = widget.employee!.phone;
      _positionController.text = widget.employee!.position;
      _departmentController.text = widget.employee!.department;
      _salaryController.text = widget.employee!.monthlySalary.toString();
      _cnpsController.text = widget.employee!.cnpsNumber ?? '';
      _contractType = widget.employee!.contractType;
      _status = widget.employee!.status;
      _hireDate = widget.employee!.hireDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.employee == null ? 'Nouvel Employé' : 'Modifier Employé'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'Prénom'),
                      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Nom'),
                      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value?.contains('@') ?? false ? null : 'Email invalide',
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _positionController,
                      decoration: const InputDecoration(labelText: 'Poste'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(labelText: 'Département'),
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _contractType,
                decoration: const InputDecoration(labelText: 'Type de contrat'),
                items: contractTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _contractType = value!),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Statut'),
                items: statuses.map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salaire mensuel (XOF)'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null ? 'Salaire invalide' : null,
              ),
              TextFormField(
                controller: _cnpsController,
                decoration: const InputDecoration(labelText: 'Numéro CNPS'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveEmployee,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveEmployee() {
    if (_formKey.currentState?.validate() ?? false) {
      final employee = Employee(
        id: widget.employee?.id ?? DateTime.now().toString(),
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        position: _positionController.text,
        department: _departmentController.text,
        contractType: _contractType,
        hireDate: _hireDate,
        monthlySalary: double.parse(_salaryController.text),
        status: _status,
        cnpsNumber: _cnpsController.text.isEmpty ? null : _cnpsController.text,
      );
      Navigator.of(context).pop(employee);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _salaryController.dispose();
    _cnpsController.dispose();
    super.dispose();
  }
}

class LeaveRequestFormDialog extends StatefulWidget {
  final List<Employee> employees;

  const LeaveRequestFormDialog({super.key, required this.employees});

  @override
  State<LeaveRequestFormDialog> createState() => _LeaveRequestFormDialogState();
}

class _LeaveRequestFormDialogState extends State<LeaveRequestFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  String? _selectedEmployeeId;
  String _leaveType = 'Congés annuels';
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 8));

  final List<String> leaveTypes = ['Congés annuels', 'Congé maladie', 'Congé maternité', 'Congé paternité', 'Autre'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle Demande de Congé'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedEmployeeId,
                decoration: const InputDecoration(labelText: 'Employé'),
                items: widget.employees.map((employee) {
                  return DropdownMenuItem(
                    value: employee.id,
                    child: Text('${employee.firstName} ${employee.lastName}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedEmployeeId = value),
                validator: (value) => value == null ? 'Sélectionnez un employé' : null,
              ),
              DropdownButtonFormField<String>(
                value: _leaveType,
                decoration: const InputDecoration(labelText: 'Type de congé'),
                items: leaveTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _leaveType = value!),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Date début'),
                      readOnly: true,
                      controller: TextEditingController(
                        text: '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Date fin'),
                      readOnly: true,
                      controller: TextEditingController(
                        text: '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: 'Motif'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _saveLeaveRequest,
          child: const Text('Soumettre'),
        ),
      ],
    );
  }

  void _saveLeaveRequest() {
    if (_formKey.currentState?.validate() ?? false && _selectedEmployeeId != null) {
      final employee = widget.employees.firstWhere((e) => e.id == _selectedEmployeeId);
      final leaveRequest = LeaveRequest(
        id: DateTime.now().toString(),
        employeeId: _selectedEmployeeId!,
        employeeName: '${employee.firstName} ${employee.lastName}',
        type: _leaveType,
        startDate: _startDate,
        endDate: _endDate,
        status: 'En attente',
        reason: _reasonController.text,
      );
      Navigator.of(context).pop(leaveRequest);
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}

class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String reason;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.reason,
  });

  LeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? type,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? reason,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }
}