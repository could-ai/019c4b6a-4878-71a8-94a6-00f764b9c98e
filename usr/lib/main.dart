import 'package:flutter/material.dart';
import 'package:couldai_user_app/layout/app_layout.dart';
import 'package:couldai_user_app/pages/dashboard_page.dart';
import 'package:couldai_user_app/pages/clients_page.dart';
import 'package:couldai_user_app/pages/sales_page.dart';
import 'package:couldai_user_app/pages/expenses_page.dart';
import 'package:couldai_user_app/pages/accounting_page.dart';
import 'package:couldai_user_app/pages/hr_page.dart';
import 'package:couldai_user_app/pages/tax_page.dart';
import 'package:couldai_user_app/pages/settings_page.dart';

void main() {
  runApp(const DaafApp());
}

class DaafApp extends StatelessWidget {
  const DaafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DAAF - Bureau Digital Universel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A), // Bleu foncé professionnel (Slate 900)
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF3B82F6), // Bleu vif (Blue 500)
          surface: const Color(0xFFF8FAFC), // Gris très clair (Slate 50)
          background: const Color(0xFFF1F5F9), // Gris clair (Slate 100)
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE2E8F0)), // Bordure subtile
          ),
          color: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF0F172A),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: Color(0xFF0F172A),
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Color(0xFF94A3B8)),
          selectedLabelTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          unselectedLabelTextStyle: TextStyle(color: Color(0xFF94A3B8)),
          useIndicator: true,
          indicatorColor: Color(0xFF3B82F6),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AppLayout(initialPage: 0),
        '/dashboard': (context) => const AppLayout(initialPage: 0),
        '/clients': (context) => const AppLayout(initialPage: 1),
        '/sales': (context) => const AppLayout(initialPage: 2),
        '/expenses': (context) => const AppLayout(initialPage: 3),
        '/accounting': (context) => const AppLayout(initialPage: 4),
        '/hr': (context) => const AppLayout(initialPage: 5),
        '/tax': (context) => const AppLayout(initialPage: 6),
        '/settings': (context) => const AppLayout(initialPage: 7),
      },
    );
  }
}
