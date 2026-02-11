import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/client.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Client> clients = [
    Client(
      id: '1',
      name: 'Tech Solutions SARL',
      email: 'contact@techsol.com',
      phone: '+221 77 000 00 00',
      type: 'Entreprise',
      status: 'Actif',
      taxExemption: false,
    ),
    Client(
      id: '2',
      name: 'Jean Dupont',
      email: 'jean.d@gmail.com',
      phone: '+225 07 00 00 00',
      type: 'Particulier',
      status: 'Prospect',
      taxExemption: false,
    ),
    Client(
      id: '3',
      name: 'Global Import Export',
      email: 'info@gie.sn',
      phone: '+221 76 111 22 33',
      type: 'Entreprise',
      status: 'Actif',
      taxExemption: true,
    ),
    Client(
      id: '4',
      name: 'Cabinet Alpha',
      email: 'alpha@cabinet.ci',
      phone: '+225 05 55 44 33',
      type: 'Entreprise',
      status: 'Inactif',
      taxExemption: false,
    ),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredClients = clients.where((client) {
      return client.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
             client.email.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Gestion des Clients",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddClientDialog(),
                icon: const Icon(Icons.add),
                label: const Text("Nouveau Client"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      onChanged: (value) => setState(() => searchQuery = value),
                      decoration: InputDecoration(
                        hintText: "Rechercher un client...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  ),
                  // Client Table
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
                        columns: const [
                          DataColumn(label: Text('Nom / Raison Sociale')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Téléphone')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Statut')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: filteredClients.map((client) => _buildClientRow(client)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildClientRow(Client client) {
    return DataRow(cells: [
      DataCell(Text(client.name, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(client.email)),
      DataCell(Text(client.phone)),
      DataCell(Text(client.type)),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: client.status == "Actif" ? Colors.green[100] : (client.status == "Prospect" ? Colors.blue[100] : Colors.grey[200]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            client.status,
            style: TextStyle(
              color: client.status == "Actif" ? Colors.green[800] : (client.status == "Prospect" ? Colors.blue[800] : Colors.grey[800]),
              fontSize: 12,
            ),
          ),
        ),
      ),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () => _showEditClientDialog(client),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
            onPressed: () => _deleteClient(client),
          ),
          IconButton(
            icon: const Icon(Icons.print, size: 20),
            onPressed: () {}, // Rapport client
          ),
        ],
      )),
    ]);
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (context) => const ClientFormDialog(),
    ).then((newClient) {
      if (newClient != null) {
        setState(() {
          clients.add(newClient);
        });
      }
    });
  }

  void _showEditClientDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) => ClientFormDialog(client: client),
    ).then((updatedClient) {
      if (updatedClient != null) {
        setState(() {
          final index = clients.indexWhere((c) => c.id == client.id);
          if (index != -1) {
            clients[index] = updatedClient;
          }
        });
      }
    });
  }

  void _deleteClient(Client client) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${client.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                clients.removeWhere((c) => c.id == client.id);
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

class ClientFormDialog extends StatefulWidget {
  final Client? client;

  const ClientFormDialog({super.key, this.client});

  @override
  State<ClientFormDialog> createState() => _ClientFormDialogState();
}

class _ClientFormDialogState extends State<ClientFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _type = 'Entreprise';
  String _status = 'Prospect';
  bool _taxExemption = false;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _nameController.text = widget.client!.name;
      _emailController.text = widget.client!.email;
      _phoneController.text = widget.client!.phone;
      _type = widget.client!.type;
      _status = widget.client!.status;
      _taxExemption = widget.client!.taxExemption;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.client == null ? 'Nouveau Client' : 'Modifier Client'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom / Raison Sociale'),
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
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
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Entreprise', 'Particulier'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => setState(() => _type = value!),
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Statut'),
                items: ['Prospect', 'Actif', 'Inactif'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              CheckboxListTile(
                title: const Text('Exonération de TVA'),
                value: _taxExemption,
                onChanged: (value) => setState(() => _taxExemption = value!),
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
          onPressed: _saveClient,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveClient() {
    if (_formKey.currentState?.validate() ?? false) {
      final client = Client(
        id: widget.client?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        type: _type,
        status: _status,
        taxExemption: _taxExemption,
      );
      Navigator.of(context).pop(client);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}