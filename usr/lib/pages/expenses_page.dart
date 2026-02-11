import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/expense.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Loyer Bureau',
      supplier: 'Agence Immobilière',
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 1500000,
      vatRate: 18.0,
      category: 'Loyer',
      paymentMethod: 'Banque',
      deductibleVat: 270000,
      proratedDeduction: 100.0,
    ),
    Expense(
      id: '2',
      title: 'Matériel Informatique',
      supplier: 'Tech Store',
      date: DateTime.now().subtract(const Duration(days: 10)),
      amount: 800000,
      vatRate: 18.0,
      category: 'Fournitures',
      paymentMethod: 'Caisse',
      deductibleVat: 144000,
      proratedDeduction: 100.0,
    ),
  ];

  String searchQuery = '';
  String selectedCategory = 'Toutes';
  DateTime? startDate;
  DateTime? endDate;

  final List<String> categories = [
    'Toutes',
    'Fournitures',
    'Loyer',
    'Salaires',
    'Marketing',
    'Déplacement',
    'Logiciels',
    'Autre',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = expenses.where((expense) {
      final matchesSearch = expense.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                           expense.supplier.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory = selectedCategory == 'Toutes' || expense.category == selectedCategory;
      final matchesDate = (startDate == null || expense.date.isAfter(startDate!)) &&
                         (endDate == null || expense.date.isBefore(endDate!.add(const Duration(days: 1))));
      return matchesSearch && matchesCategory && matchesDate;
    }).toList();

    final totalAmount = filteredExpenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final totalDeductibleVat = filteredExpenses.fold<double>(0, (sum, expense) => sum + expense.deductibleVat);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Dépenses",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddExpenseDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Nouvelle Dépense"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Dépenses', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('${totalAmount.toStringAsFixed(0)} XOF', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('TVA Déductible', style: TextStyle(fontSize: 14, color: Colors.grey)),
                        Text('${totalDeductibleVat.toStringAsFixed(0)} XOF', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Filters
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: const InputDecoration(
                            hintText: "Rechercher...",
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(labelText: 'Catégorie'),
                          items: categories.map((category) {
                            return DropdownMenuItem(value: category, child: Text(category));
                          }).toList(),
                          onChanged: (value) => setState(() => selectedCategory = value!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Expenses Table
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                      columns: const [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Titre')),
                        DataColumn(label: Text('Fournisseur')),
                        DataColumn(label: Text('Catégorie')),
                        DataColumn(label: Text('Montant TTC')),
                        DataColumn(label: Text('TVA Déductible')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: filteredExpenses.map((expense) => _buildExpenseRow(expense)).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildExpenseRow(Expense expense) {
    return DataRow(cells: [
      DataCell(Text('${expense.date.day}/${expense.date.month}/${expense.date.year}')),      DataCell(Text(expense.title, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(expense.supplier)),
      DataCell(Text(expense.category)),
      DataCell(Text('${expense.amount} XOF')),
      DataCell(Text('${expense.deductibleVat} XOF')),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditExpenseDialog(expense),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _deleteExpense(expense),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, size: 20),
            onPressed: () {}, // Justificatif
          ),
        ],
      )),
    ]);
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => const ExpenseFormDialog(),
    ).then((newExpense) {
      if (newExpense != null) {
        setState(() {
          expenses.add(newExpense);
        });
      }
    });
  }

  void _showEditExpenseDialog(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => ExpenseFormDialog(expense: expense),
    ).then((updatedExpense) {
      if (updatedExpense != null) {
        setState(() {
          final index = expenses.indexWhere((e) => e.id == expense.id);
          if (index != -1) {
            expenses[index] = updatedExpense;
          }
        });
      }
    });
  }

  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${expense.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                expenses.removeWhere((e) => e.id == expense.id);
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
}

class ExpenseFormDialog extends StatefulWidget {
  final Expense? expense;

  const ExpenseFormDialog({super.key, this.expense});

  @override
  State<ExpenseFormDialog> createState() => _ExpenseFormDialogState();
}

class _ExpenseFormDialogState extends State<ExpenseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _supplierController = TextEditingController();
  final _amountController = TextEditingController();
  final _vatRateController = TextEditingController(text: '18');
  final _deductibleVatController = TextEditingController();
  final _referenceController = TextEditingController();
  DateTime _date = DateTime.now();
  String _category = 'Fournitures';
  String _paymentMethod = 'Banque';
  double _proratedDeduction = 100.0;

  final List<String> categories = [
    'Fournitures',
    'Loyer',
    'Salaires',
    'Marketing',
    'Déplacement',
    'Logiciels',
    'Autre',
  ];

  final List<String> paymentMethods = [
    'Banque',
    'Caisse',
    'À crédit',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _supplierController.text = widget.expense!.supplier;
      _amountController.text = widget.expense!.amount.toString();
      _vatRateController.text = widget.expense!.vatRate.toString();
      _deductibleVatController.text = widget.expense!.deductibleVat.toString();
      _referenceController.text = widget.expense!.reference ?? '';
      _date = widget.expense!.date;
      _category = widget.expense!.category;
      _paymentMethod = widget.expense!.paymentMethod;
      _proratedDeduction = widget.expense!.proratedDeduction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.expense == null ? 'Nouvelle Dépense' : 'Modifier Dépense'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(labelText: 'Fournisseur'),
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Montant TTC'),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null ? 'Montant invalide' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _vatRateController,
                      decoration: const InputDecoration(labelText: 'Taux TVA (%)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _deductibleVatController,
                      decoration: const InputDecoration(labelText: 'TVA Déductible'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Catégorie'),
                items: categories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) => setState(() => _category = value!),
              ),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: 'Moyen de paiement'),
                items: paymentMethods.map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) => setState(() => _paymentMethod = value!),
              ),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(labelText: 'Référence facture'),
              ),
              Slider(
                value: _proratedDeduction,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_proratedDeduction.round()}%',
                onChanged: (value) => setState(() => _proratedDeduction = value),
              ),
              Text('Prorata de déduction: ${_proratedDeduction.round()}%'),
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
          onPressed: _saveExpense,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveExpense() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      final vatRate = double.parse(_vatRateController.text);
      final deductibleVat = double.parse(_deductibleVatController.text.isEmpty ? '0' : _deductibleVatController.text);

      final expense = Expense(
        id: widget.expense?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        supplier: _supplierController.text,
        date: _date,
        amount: amount,
        vatRate: vatRate,
        category: _category,
        paymentMethod: _paymentMethod,
        deductibleVat: deductibleVat,
        proratedDeduction: _proratedDeduction,
        reference: _referenceController.text.isEmpty ? null : _referenceController.text,
      );
      Navigator.of(context).pop(expense);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _supplierController.dispose();
    _amountController.dispose();
    _vatRateController.dispose();
    _deductibleVatController.dispose();
    _referenceController.dispose();
    super.dispose();
  }
}