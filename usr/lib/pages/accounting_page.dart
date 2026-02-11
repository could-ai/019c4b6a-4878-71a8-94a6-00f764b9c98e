import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/accounting_entry.dart';

class AccountingPage extends StatefulWidget {
  const AccountingPage({super.key});

  @override
  State<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends State<AccountingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<AccountingEntry> journalEntries = [
    AccountingEntry(
      id: '1',
      entryNumber: 1,
      date: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Facture client Tech Solutions',
      accountNumber: '411000',
      accountName: 'Clients',
      debit: 500000,
      credit: 0,
    ),
    AccountingEntry(
      id: '2',
      date: DateTime.now().subtract(const Duration(days: 5)),
      description: 'Facture client Tech Solutions',
      accountNumber: '701000',
      accountName: 'Ventes de prestations',
      debit: 0,
      credit: 500000,
    ),
    AccountingEntry(
      id: '3',
      entryNumber: 2,
      date: DateTime.now().subtract(const Duration(days: 3)),
      description: 'Loyer bureau',
      accountNumber: '613000',
      accountName: 'Locations diverses',
      debit: 1500000,
      credit: 0,
    ),
  ];

  List<BalanceEntry> balanceEntries = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _calculateBalance();
  }

  void _calculateBalance() {
    final accountMap = <String, BalanceEntry>{};
    for (final entry in journalEntries) {
      final key = '${entry.accountNumber}-${entry.accountName}';
      if (!accountMap.containsKey(key)) {
        accountMap[key] = BalanceEntry(
          accountNumber: entry.accountNumber,
          accountName: entry.accountName,
          debit: 0,
          credit: 0,
        );
      }
      accountMap[key]!.debit += entry.debit;
      accountMap[key]!.credit += entry.credit;
    }
    balanceEntries = accountMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Comptabilité",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Journal'),
              Tab(text: 'Balance'),
              Tab(text: 'Comptes de Résultat'),
              Tab(text: 'Bilan'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildJournalTab(),
                _buildBalanceTab(),
                _buildIncomeStatementTab(),
                _buildBalanceSheetTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Journal Comptable', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showAddEntryDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Nouvelle Écriture'),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {},
                      tooltip: 'Exporter CSV',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                  columns: const [
                    DataColumn(label: Text('N° Écriture')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Compte')),
                    DataColumn(label: Text('Débit')),
                    DataColumn(label: Text('Crédit')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: journalEntries.map((entry) => _buildJournalRow(entry)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Balance des Comptes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                  columns: const [
                    DataColumn(label: Text('N° Compte')),
                    DataColumn(label: Text('Intitulé')),
                    DataColumn(label: Text('Débit')),
                    DataColumn(label: Text('Crédit')),
                    DataColumn(label: Text('Solde')),
                  ],
                  rows: balanceEntries.map((entry) => _buildBalanceRow(entry)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeStatementTab() {
    // Simplified income statement
    final revenues = journalEntries.where((e) => e.accountNumber.startsWith('7')).fold<double>(0, (sum, e) => sum + e.credit);
    final expenses = journalEntries.where((e) => e.accountNumber.startsWith('6')).fold<double>(0, (sum, e) => sum + e.debit);
    final result = revenues - expenses;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Compte de Résultat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildStatementRow('Produits', revenues),
            const SizedBox(height: 8),
            _buildStatementRow('Charges', expenses),
            const Divider(),
            _buildStatementRow('Résultat', result, isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSheetTab() {
    // Simplified balance sheet
    final assets = journalEntries.where((e) => e.accountNumber.startsWith('2') || e.accountNumber.startsWith('3')).fold<double>(0, (sum, e) => sum + e.debit);
    final liabilities = journalEntries.where((e) => e.accountNumber.startsWith('4') || e.accountNumber.startsWith('5')).fold<double>(0, (sum, e) => sum + e.credit);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bilan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('ACTIF', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildStatementRow('Actifs', assets),
            const SizedBox(height: 24),
            const Text('PASSIF', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildStatementRow('Passifs', liabilities),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text('${amount.toStringAsFixed(0)} XOF', style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  DataRow _buildJournalRow(AccountingEntry entry) {
    return DataRow(cells: [
      DataCell(Text(entry.entryNumber?.toString() ?? '')),
      DataCell(Text('${entry.date.day}/${entry.date.month}/${entry.date.year}')),
      DataCell(Text(entry.description)),
      DataCell(Text('${entry.accountNumber} - ${entry.accountName}')),
      DataCell(Text(entry.debit > 0 ? '${entry.debit} XOF' : '')),
      DataCell(Text(entry.credit > 0 ? '${entry.credit} XOF' : '')),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditEntryDialog(entry),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _deleteEntry(entry),
          ),
        ],
      )),
    ]);
  }

  DataRow _buildBalanceRow(BalanceEntry entry) {
    final balance = entry.debit - entry.credit;
    return DataRow(cells: [
      DataCell(Text(entry.accountNumber)),
      DataCell(Text(entry.accountName)),
      DataCell(Text('${entry.debit} XOF')),
      DataCell(Text('${entry.credit} XOF')),
      DataCell(Text('${balance.abs()} XOF', style: TextStyle(color: balance >= 0 ? Colors.green : Colors.red))),
    ]);
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => const AccountingEntryFormDialog(),
    ).then((newEntry) {
      if (newEntry != null) {
        setState(() {
          journalEntries.add(newEntry);
          _calculateBalance();
        });
      }
    });
  }

  void _showEditEntryDialog(AccountingEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AccountingEntryFormDialog(entry: entry),
    ).then((updatedEntry) {
      if (updatedEntry != null) {
        setState(() {
          final index = journalEntries.indexWhere((e) => e.id == entry.id);
          if (index != -1) {
            journalEntries[index] = updatedEntry;
            _calculateBalance();
          }
        });
      }
    });
  }

  void _deleteEntry(AccountingEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette écriture ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                journalEntries.removeWhere((e) => e.id == entry.id);
                _calculateBalance();
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class AccountingEntryFormDialog extends StatefulWidget {
  final AccountingEntry? entry;

  const AccountingEntryFormDialog({super.key, this.entry});

  @override
  State<AccountingEntryFormDialog> createState() => _AccountingEntryFormDialogState();
}

class _AccountingEntryFormDialogState extends State<AccountingEntryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _debitController = TextEditingController();
  final _creditController = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _descriptionController.text = widget.entry!.description;
      _accountNumberController.text = widget.entry!.accountNumber;
      _accountNameController.text = widget.entry!.accountName;
      _debitController.text = widget.entry!.debit.toString();
      _creditController.text = widget.entry!.credit.toString();
      _date = widget.entry!.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.entry == null ? 'Nouvelle Écriture' : 'Modifier Écriture'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _accountNumberController,
                      decoration: const InputDecoration(labelText: 'N° Compte'),
                      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _accountNameController,
                      decoration: const InputDecoration(labelText: 'Intitulé Compte'),
                      validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _debitController,
                      decoration: const InputDecoration(labelText: 'Débit'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _creditController,
                      decoration: const InputDecoration(labelText: 'Crédit'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
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
          onPressed: _saveEntry,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveEntry() {
    if (_formKey.currentState?.validate() ?? false) {
      final entry = AccountingEntry(
        id: widget.entry?.id ?? DateTime.now().toString(),
        entryNumber: widget.entry?.entryNumber ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000),
        date: _date,
        description: _descriptionController.text,
        accountNumber: _accountNumberController.text,
        accountName: _accountNameController.text,
        debit: double.tryParse(_debitController.text) ?? 0,
        credit: double.tryParse(_creditController.text) ?? 0,
      );
      Navigator.of(context).pop(entry);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _debitController.dispose();
    _creditController.dispose();
    super.dispose();
  }
}

class BalanceEntry {
  final String accountNumber;
  final String accountName;
  double debit;
  double credit;

  BalanceEntry({
    required this.accountNumber,
    required this.accountName,
    required this.debit,
    required this.credit,
  });
}