import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/quote.dart';
import 'package:couldai_user_app/models/invoice.dart';
import 'package:couldai_user_app/models/client.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final List<Quote> quotes = [
    Quote(
      id: '1',
      number: 'DEV-001',
      clientId: '1',
      clientName: 'Tech Solutions SARL',
      date: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      status: 'Envoyé',
      items: [QuoteItem(description: 'Développement logiciel', quantity: 1, price: 5000000)],
      total: 5000000,
    ),
  ];

  final List<Invoice> invoices = [
    Invoice(
      id: '1',
      number: 'INV-001',
      clientId: '1',
      clientName: 'Tech Solutions SARL',
      date: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      status: 'Payée',
      items: [InvoiceItem(description: 'Consulting', quantity: 20, price: 25000)],
      total: 500000,
      paidAmount: 500000,
    ),
  ];

  final List<Client> clients = [
    Client(
      id: '1', 
      name: 'Tech Solutions SARL', 
      email: 'contact@techsol.com',
      phone: '+225 01010101',
      type: 'Entreprise',
      status: 'Actif',
    ),
    Client(
      id: '2', 
      name: 'Jean Dupont', 
      email: 'jean.d@gmail.com',
      phone: '+225 02020202',
      type: 'Particulier',
      status: 'Actif',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                "Ventes",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Nouveau"),
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
              Tab(text: 'Devis'),
              Tab(text: 'Factures'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuotesTab(),
                _buildInvoicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotesTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return ListTile(
                    title: Text('${quote.number} - ${quote.clientName}'),
                    subtitle: Text('Montant: ${quote.total} XOF - Statut: ${quote.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editQuote(quote),
                        ),
                        IconButton(
                          icon: const Icon(Icons.print),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {},
                        ),
                      ],
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

  Widget _buildInvoicesTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  final invoice = invoices[index];
                  return ListTile(
                    title: Text('${invoice.number} - ${invoice.clientName}'),
                    subtitle: Text('Montant: ${invoice.total} XOF - Statut: ${invoice.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editInvoice(invoice),
                        ),
                        IconButton(
                          icon: const Icon(Icons.payment),
                          onPressed: () => _recordPayment(invoice),
                        ),
                        IconButton(
                          icon: const Icon(Icons.print),
                          onPressed: () {},
                        ),
                      ],
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

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Nouveau Devis'),
              onTap: () {
                Navigator.of(context).pop();
                _createQuote();
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt),
              title: const Text('Nouvelle Facture'),
              onTap: () {
                Navigator.of(context).pop();
                _createInvoice();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createQuote() {
    showDialog(
      context: context,
      builder: (context) => QuoteFormDialog(clients: clients),
    ).then((newQuote) {
      if (newQuote != null) {
        setState(() {
          quotes.add(newQuote);
        });
      }
    });
  }

  void _editQuote(Quote quote) {
    showDialog(
      context: context,
      builder: (context) => QuoteFormDialog(quote: quote, clients: clients),
    ).then((updatedQuote) {
      if (updatedQuote != null) {
        setState(() {
          final index = quotes.indexWhere((q) => q.id == quote.id);
          if (index != -1) {
            quotes[index] = updatedQuote;
          }
        });
      }
    });
  }

  void _createInvoice() {
    showDialog(
      context: context,
      builder: (context) => InvoiceFormDialog(clients: clients),
    ).then((newInvoice) {
      if (newInvoice != null) {
        setState(() {
          invoices.add(newInvoice);
        });
      }
    });
  }

  void _editInvoice(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceFormDialog(invoice: invoice, clients: clients),
    ).then((updatedInvoice) {
      if (updatedInvoice != null) {
        setState(() {
          final index = invoices.indexWhere((i) => i.id == invoice.id);
          if (index != -1) {
            invoices[index] = updatedInvoice;
          }
        });
      }
    });
  }

  void _recordPayment(Invoice invoice) {
    showDialog(
      context: context,
      builder: (context) => PaymentDialog(invoice: invoice),
    ).then((payment) {
      if (payment != null) {
        setState(() {
          final index = invoices.indexWhere((i) => i.id == invoice.id);
          if (index != -1) {
            final newPaidAmount = invoices[index].paidAmount + payment;
            final newStatus = newPaidAmount >= invoices[index].total ? 'Payée' : 'Partiellement payée';
            invoices[index] = invoices[index].copyWith(
              paidAmount: newPaidAmount,
              status: newStatus,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class QuoteFormDialog extends StatefulWidget {
  final Quote? quote;
  final List<Client> clients;

  const QuoteFormDialog({super.key, this.quote, required this.clients});

  @override
  State<QuoteFormDialog> createState() => _QuoteFormDialogState();
}

class _QuoteFormDialogState extends State<QuoteFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  final _items = <QuoteItem>[];
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    if (widget.quote != null) {
      _selectedClientId = widget.quote!.clientId;
      _items.addAll(widget.quote!.items);
      _expiryDate = widget.quote!.expiryDate;
    } else {
      _items.add(QuoteItem(description: '', quantity: 1, price: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.quote == null ? 'Nouveau Devis' : 'Modifier Devis'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedClientId,
                decoration: const InputDecoration(labelText: 'Client'),
                items: widget.clients.map((client) {
                  return DropdownMenuItem(
                    value: client.id,
                    child: Text(client.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedClientId = value),
                validator: (value) => value == null ? 'Sélectionnez un client' : null,
              ),
              // Items list (simplified)
              const SizedBox(height: 16),
              const Text('Articles', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._items.map((item) => ListTile(
                title: Text(item.description.isEmpty ? 'Nouvel article' : item.description),
                subtitle: Text('Qté: ${item.quantity} x ${item.price} XOF'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _items.remove(item)),
                ),
              )),
              TextButton(
                onPressed: () => setState(() => _items.add(QuoteItem(description: '', quantity: 1, price: 0))),
                child: const Text('Ajouter un article'),
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
          onPressed: _saveQuote,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveQuote() {
    if (_formKey.currentState?.validate() ?? false) {
      final client = widget.clients.firstWhere((c) => c.id == _selectedClientId);
      final quote = Quote(
        id: widget.quote?.id ?? DateTime.now().toString(),
        number: widget.quote?.number ?? 'DEV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        clientId: _selectedClientId!,
        clientName: client.name,
        date: DateTime.now(),
        expiryDate: _expiryDate,
        status: 'Brouillon',
        items: _items,
        total: _items.fold(0, (sum, item) => sum + (item.quantity * item.price)),
      );
      Navigator.of(context).pop(quote);
    }
  }
}

class InvoiceFormDialog extends StatefulWidget {
  final Invoice? invoice;
  final List<Client> clients;

  const InvoiceFormDialog({super.key, this.invoice, required this.clients});

  @override
  State<InvoiceFormDialog> createState() => _InvoiceFormDialogState();
}

class _InvoiceFormDialogState extends State<InvoiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  final _items = <InvoiceItem>[];
  DateTime _dueDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    if (widget.invoice != null) {
      _selectedClientId = widget.invoice!.clientId;
      _items.addAll(widget.invoice!.items);
      _dueDate = widget.invoice!.dueDate;
    } else {
      _items.add(InvoiceItem(description: '', quantity: 1, price: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.invoice == null ? 'Nouvelle Facture' : 'Modifier Facture'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedClientId,
                decoration: const InputDecoration(labelText: 'Client'),
                items: widget.clients.map((client) {
                  return DropdownMenuItem(
                    value: client.id,
                    child: Text(client.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedClientId = value),
                validator: (value) => value == null ? 'Sélectionnez un client' : null,
              ),
              // Items list (simplified)
              const SizedBox(height: 16),
              const Text('Articles', style: TextStyle(fontWeight: FontWeight.bold)),
              ..._items.map((item) => ListTile(
                title: Text(item.description.isEmpty ? 'Nouvel article' : item.description),
                subtitle: Text('Qté: ${item.quantity} x ${item.price} XOF'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _items.remove(item)),
                ),
              )),
              TextButton(
                onPressed: () => setState(() => _items.add(InvoiceItem(description: '', quantity: 1, price: 0))),
                child: const Text('Ajouter un article'),
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
          onPressed: _saveInvoice,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveInvoice() {
    if (_formKey.currentState?.validate() ?? false) {
      final client = widget.clients.firstWhere((c) => c.id == _selectedClientId);
      final invoice = Invoice(
        id: widget.invoice?.id ?? DateTime.now().toString(),
        number: widget.invoice?.number ?? 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        clientId: _selectedClientId!,
        clientName: client.name,
        date: DateTime.now(),
        dueDate: _dueDate,
        status: 'Brouillon',
        items: _items,
        total: _items.fold(0, (sum, item) => sum + (item.quantity * item.price)),
        paidAmount: 0,
      );
      Navigator.of(context).pop(invoice);
    }
  }
}

class PaymentDialog extends StatefulWidget {
  final Invoice invoice;

  const PaymentDialog({super.key, required this.invoice});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final remaining = widget.invoice.total - widget.invoice.paidAmount;
    return AlertDialog(
      title: const Text('Enregistrer un paiement'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Montant restant: ${remaining} XOF'),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Montant du paiement'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final amount = double.tryParse(value ?? '') ?? 0;
                if (amount <= 0) return 'Montant invalide';
                if (amount > remaining) return 'Montant supérieur au restant';
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _savePayment,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _savePayment() {
    if (_formKey.currentState?.validate() ?? false) {
      final amount = double.parse(_amountController.text);
      Navigator.of(context).pop(amount);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}
