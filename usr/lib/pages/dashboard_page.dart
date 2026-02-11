import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/models.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Mock data for dashboard
  double totalRevenue = 12450000;
  double totalExpenses = 4200000;
  double netResult = 8250000;
  int activeClients = 142;
  int pendingInvoices = 8;

  final List<Map<String, dynamic>> recentActivities = [
    {'title': 'Facture #INV-001 payée', 'time': 'Il y a 2h', 'type': 'payment'},
    {'title': 'Nouveau client ajouté', 'time': 'Il y a 4h', 'type': 'client'},
    {'title': 'Dépense \'Loyer\' enregistrée', 'time': 'Hier', 'type': 'expense'},
    {'title': 'Bulletin de paie généré', 'time': 'Hier', 'type': 'payroll'},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vue d'ensemble",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          // KPI Cards Row
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              int crossAxisCount = width > 1200 ? 4 : (width > 800 ? 2 : 1);
              
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                childAspectRatio: 1.8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildKpiCard(
                    context,
                    "Chiffre d'Affaires",
                    "${(totalRevenue / 1000).toStringAsFixed(0)}k XOF",
                    "+12% vs mois dernier",
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildKpiCard(
                    context,
                    "Dépenses",
                    "${(totalExpenses / 1000).toStringAsFixed(0)}k XOF",
                    "-5% vs mois dernier",
                    Icons.trending_down,
                    Colors.red,
                  ),
                  _buildKpiCard(
                    context,
                    "Résultat Net",
                    "${(netResult / 1000).toStringAsFixed(0)}k XOF",
                    "+22% vs mois dernier",
                    Icons.account_balance,
                    Colors.blue,
                  ),
                  _buildKpiCard(
                    context,
                    "Clients Actifs",
                    activeClients.toString(),
                    "+8 nouveaux",
                    Icons.people,
                    Colors.orange,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Charts and Activities
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Évolution Revenus vs Dépenses", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        Container(
                          height: 300,
                          color: Colors.grey[100],
                          child: const Center(child: Text("Graphique (Intégration fl_chart à venir)")),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Activités Récentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Voir tout'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...recentActivities.map((activity) => _buildActivityItem(activity)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Subscription Banner
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Plan PME - 99 000 XOF/mois',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Échéance le 15 décembre 2024',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Mettre à niveau'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    IconData icon;
    Color color;
    
    switch (activity['type']) {
      case 'payment':
        icon = Icons.payment;
        color = Colors.green;
        break;
      case 'client':
        icon = Icons.person_add;
        color = Colors.blue;
        break;
      case 'expense':
        icon = Icons.receipt;
        color = Colors.orange;
        break;
      case 'payroll':
        icon = Icons.account_balance_wallet;
        color = Colors.purple;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(activity['title'], style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(activity['time'], style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}