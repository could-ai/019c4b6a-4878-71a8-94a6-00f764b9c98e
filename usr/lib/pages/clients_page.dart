import 'package:flutter/material.dart';

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

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
              const Text("Gestion des Clients", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
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
                      rows: [
                        _buildClientRow("Tech Solutions SARL", "contact@techsol.com", "+221 77 000 00 00", "Entreprise", "Actif"),
                        _buildClientRow("Jean Dupont", "jean.d@gmail.com", "+225 07 00 00 00", "Particulier", "Prospect"),
                        _buildClientRow("Global Import Export", "info@gie.sn", "+221 76 111 22 33", "Entreprise", "Actif"),
                        _buildClientRow("Cabinet Alpha", "alpha@cabinet.ci", "+225 05 55 44 33", "Entreprise", "Inactif"),
                      ],
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

  DataRow _buildClientRow(String name, String email, String phone, String type, String status) {
    return DataRow(cells: [
      DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(Text(email)),
      DataCell(Text(phone)),
      DataCell(Text(type)),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status == "Actif" ? Colors.green[100] : (status == "Prospect" ? Colors.blue[100] : Colors.grey[200]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: status == "Actif" ? Colors.green[800] : (status == "Prospect" ? Colors.blue[800] : Colors.grey[800]),
              fontSize: 12,
            ),
          ),
        ),
      ),
      DataCell(Row(
        children: [
          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete, size: 20, color: Colors.red), onPressed: () {}),
        ],
      )),
    ]);
  }
}
