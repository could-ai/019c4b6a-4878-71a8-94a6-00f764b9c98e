import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                    "12,450,000 XOF",
                    "+12% vs mois dernier",
                    Icons.trending_up,
                    Colors.green,
                  ),
                  _buildKpiCard(
                    context,
                    "Dépenses",
                    "4,200,000 XOF",
                    "-5% vs mois dernier",
                    Icons.trending_down,
                    Colors.red,
                  ),
                  _buildKpiCard(
                    context,
                    "Résultat Net",
                    "8,250,000 XOF",
                    "+22% vs mois dernier",
                    Icons.account_balance,
                    Colors.blue,
                  ),
                  _buildKpiCard(
                    context,
                    "Clients Actifs",
                    "142",
                    "+8 nouveaux",
                    Icons.people,
                    Colors.orange,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          
          // Recent Activity & Charts Placeholder
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
                          child: const Center(child: Text("Graphique (À implémenter avec fl_chart)")),
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
                        const Text("Activités Récentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        _buildActivityItem("Facture #INV-001 payée", "Il y a 2h", Colors.green),
                        _buildActivityItem("Nouveau client ajouté", "Il y a 4h", Colors.blue),
                        _buildActivityItem("Dépense 'Loyer' enregistrée", "Hier", Colors.orange),
                        _buildActivityItem("Bulletin de paie généré", "Hier", Colors.purple),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildActivityItem(String title, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }
}
