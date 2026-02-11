import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/tax_declaration.dart';

class TaxPage extends StatefulWidget {
  const TaxPage({super.key});

  @override
  State<TaxPage> createState() => _TaxPageState();
}

class _TaxPageState extends State<TaxPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<TaxDeclaration> taxDeclarations = [
    TaxDeclaration(
      id: '1',
      type: 'TVA',
      period: 'Mars 2024',
      status: 'À déclarer',
      amount: 450000,
      dueDate: DateTime(2024, 4, 20),
    ),
    TaxDeclaration(
      id: '2',
      type: 'IS',
      period: '2023',
      status: 'Déclarée',
      amount: 1200000,
      dueDate: DateTime(2024, 3, 31),
      paymentDate: DateTime(2024, 3, 15),
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
          const Text(
            "Fiscalité",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Déclarations'),
              Tab(text: 'Calendrier'),
              Tab(text: 'Rapports'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDeclarationsTab(),
                _buildCalendarTab(),
                _buildReportsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclarationsTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Déclarations Fiscales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showNewDeclarationDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle Déclaration'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: taxDeclarations.length,
                itemBuilder: (context, index) {
                  final declaration = taxDeclarations[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text('${declaration.type} - ${declaration.period}'),
                      subtitle: Text('Montant: ${declaration.amount} XOF • Échéance: ${declaration.dueDate.day}/${declaration.dueDate.month}/${declaration.dueDate.year}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: declaration.status == 'À déclarer' ? Colors.orange[100] :
                                     declaration.status == 'Déclarée' ? Colors.green[100] : Colors.blue[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              declaration.status,
                              style: TextStyle(
                                color: declaration.status == 'À déclarer' ? Colors.orange[800] :
                                       declaration.status == 'Déclarée' ? Colors.green[800] : Colors.blue[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (declaration.status == 'À déclarer')
                            ElevatedButton(
                              onPressed: () => _fileDeclaration(declaration),
                              child: const Text('Déclarer'),
                            ),
                          if (declaration.status == 'Déclarée' && declaration.paymentDate == null)
                            ElevatedButton(
                              onPressed: () => _payDeclaration(declaration),
                              child: const Text('Payer'),
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

  Widget _buildCalendarTab() {
    final upcomingDeclarations = taxDeclarations.where((d) => d.status == 'À déclarer').toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Calendrier Fiscal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Échéances à venir:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: upcomingDeclarations.length,
                itemBuilder: (context, index) {
                  final declaration = upcomingDeclarations[index];
                  final daysUntilDue = declaration.dueDate.difference(DateTime.now()).inDays;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: daysUntilDue <= 7 ? Colors.red[50] : Colors.orange[50],
                    child: ListTile(
                      leading: Icon(
                        Icons.warning,
                        color: daysUntilDue <= 7 ? Colors.red : Colors.orange,
                      ),
                      title: Text('${declaration.type} - ${declaration.period}'),
                      subtitle: Text('Échéance: ${declaration.dueDate.day}/${declaration.dueDate.month}/${declaration.dueDate.year} (${daysUntilDue} jours)'),
                      trailing: Text('${declaration.amount} XOF', style: const TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildReportsTab() {
    // Simplified tax reports
    final totalVat = taxDeclarations.where((d) => d.type == 'TVA').fold<double>(0, (sum, d) => sum + d.amount);
    final totalIs = taxDeclarations.where((d) => d.type == 'IS').fold<double>(0, (sum, d) => sum + d.amount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rapports Fiscaux', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Résumé annuel:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            _buildReportItem('TVA collectée', totalVat),
            _buildReportItem('Impôt sur les Sociétés', totalIs),
            const Divider(),
            _buildReportItem('Total des impôts', totalVat + totalIs, isTotal: true),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                  label: const Text('Exporter PDF'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.print),
                  label: const Text('Imprimer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('${amount.toStringAsFixed(0)} XOF', style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  void _showNewDeclarationDialog() {
    showDialog(
      context: context,
      builder: (context) => const TaxDeclarationFormDialog(),
    ).then((newDeclaration) {
      if (newDeclaration != null) {
        setState(() {
          taxDeclarations.add(newDeclaration);
        });
      }
    });
  }

  void _fileDeclaration(TaxDeclaration declaration) {
    setState(() {
      final index = taxDeclarations.indexWhere((d) => d.id == declaration.id);
      if (index != -1) {
        taxDeclarations[index] = declaration.copyWith(status: 'Déclarée');
      }
    });
  }

  void _payDeclaration(TaxDeclaration declaration) {
    setState(() {
      final index = taxDeclarations.indexWhere((d) => d.id == declaration.id);
      if (index != -1) {
        taxDeclarations[index] = declaration.copyWith(
          status: 'Payée',
          paymentDate: DateTime.now(),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TaxDeclarationFormDialog extends StatefulWidget {
  const TaxDeclarationFormDialog({super.key});

  @override
  State<TaxDeclarationFormDialog> createState() => _TaxDeclarationFormDialogState();
}

class _TaxDeclarationFormDialogState extends State<TaxDeclarationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _type = 'TVA';
  String _period = 'Mars 2024';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  final List<String> taxTypes = ['TVA', 'IS', 'IRPP', 'Cotisations sociales'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle Déclaration Fiscale'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type de déclaration'),
                items: taxTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Période'),
                initialValue: _period,
                onChanged: (value) => _period = value,
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Montant (XOF)'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null ? 'Montant invalide' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date d\'échéance'),
                readOnly: true,
                initialValue: '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
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
          onPressed: _saveDeclaration,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveDeclaration() {
    if (_formKey.currentState?.validate() ?? false) {
      final declaration = TaxDeclaration(
        id: DateTime.now().toString(),
        type: _type,
        period: _period,
        status: 'À déclarer',
        amount: double.parse(_amountController.text),
        dueDate: _dueDate,
      );
      Navigator.of(context).pop(declaration);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}