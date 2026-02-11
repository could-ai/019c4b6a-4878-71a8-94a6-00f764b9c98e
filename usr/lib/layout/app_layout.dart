import 'package:flutter/material.dart';
import 'package:couldai_user_app/pages/dashboard_page.dart';
import 'package:couldai_user_app/pages/clients_page.dart';
import 'package:couldai_user_app/pages/sales_page.dart';
import 'package:couldai_user_app/pages/expenses_page.dart';
import 'package:couldai_user_app/pages/accounting_page.dart';
import 'package:couldai_user_app/pages/hr_page.dart';
import 'package:couldai_user_app/pages/tax_page.dart';
import 'package:couldai_user_app/pages/settings_page.dart';

class AppLayout extends StatefulWidget {
  final int initialPage;

  const AppLayout({super.key, this.initialPage = 0});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPage;
  }

  final List<Widget> _pages = [
    const DashboardPage(),
    const ClientsPage(),
    const SalesPage(),
    const ExpensesPage(),
    const AccountingPage(),
    const HrPage(),
    const TaxPage(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    'Tableau de Bord',
    'Clients',
    'Ventes',
    'Dépenses',
    'Comptabilité',
    'Ressources Humaines',
    'Fiscalité',
    'Paramètres',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            extended: MediaQuery.of(context).size.width > 1100, // Responsive sidebar
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Column(
                children: [
                  const Icon(Icons.business_center, color: Colors.white, size: 32),
                  if (MediaQuery.of(context).size.width > 1100)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "DAAF",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Tableau de Bord'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Clients'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.shopping_cart_outlined),
                selectedIcon: Icon(Icons.shopping_cart),
                label: Text('Ventes'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: Text('Dépenses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: Text('Comptabilité'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.badge_outlined),
                selectedIcon: Icon(Icons.badge),
                label: Text('RH & Paie'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.gavel_outlined),
                selectedIcon: Icon(Icons.gavel),
                label: Text('Fiscalité'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Paramètres'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                AppBar(
                  title: Text(_titles[_selectedIndex]),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        child: const Text("JD", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
