import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Company settings
  final _companyNameController = TextEditingController(text: 'Tech Solutions SARL');
  final _rccmController = TextEditingController(text: 'CI-ABJ-2023-B-12345');
  final _nifController = TextEditingController(text: 'CI123456789');
  final _addressController = TextEditingController(text: 'Abidjan, Côte d\'Ivoire');
  String _fiscalRegime = 'Réal Normal';
  String _defaultCurrency = 'XOF';
  String _country = 'Côte d\'Ivoire';

  // Tax rules
  final List<TaxRule> taxRules = [
    TaxRule(name: 'TVA', rate: 18.0, accountNumber: '445710'),
    TaxRule(name: 'TPS', rate: 5.0, accountNumber: '445711'),
    TaxRule(name: 'TVQ', rate: 9.975, accountNumber: '445712'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Paramètres",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Entreprise'),
              Tab(text: 'Équipe'),
              Tab(text: 'Règles Fiscales'),
              Tab(text: 'Avancé'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyTab(),
                _buildTeamTab(),
                _buildTaxRulesTab(),
                _buildAdvancedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informations de l\'Entreprise', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _companyNameController,
              decoration: const InputDecoration(labelText: 'Nom de l\'entreprise'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _rccmController,
                    decoration: const InputDecoration(labelText: 'Numéro RCCM'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _nifController,
                    decoration: const InputDecoration(labelText: 'NIF/TVA'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Adresse'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _country,
                    decoration: const InputDecoration(labelText: 'Pays'),
                    items: ['Côte d\'Ivoire', 'Sénégal', 'France', 'Canada', 'Belgique'].map((country) {
                      return DropdownMenuItem(value: country, child: Text(country));
                    }).toList(),
                    onChanged: (value) => setState(() => _country = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _fiscalRegime,
                    decoration: const InputDecoration(labelText: 'Régime fiscal'),
                    items: ['Réal Normal', 'Réal Simplifié', 'Micro-entreprise'].map((regime) {
                      return DropdownMenuItem(value: regime, child: Text(regime));
                    }).toList(),
                    onChanged: (value) => setState(() => _fiscalRegime = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _defaultCurrency,
              decoration: const InputDecoration(labelText: 'Devise par défaut'),
              items: ['XOF', 'EUR', 'USD', 'CAD'].map((currency) {
                return DropdownMenuItem(value: currency, child: Text(currency));
              }).toList(),
              onChanged: (value) => setState(() => _defaultCurrency = value!),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Télécharger Logo'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Signature Numérisée'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveCompanySettings,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Enregistrer les Modifications'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gestion d\'Équipe', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showInviteMemberDialog(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Inviter un Membre'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Mock team members
            _buildTeamMember('Jean Dupont', 'jean.dupont@email.com', 'Admin'),
            _buildTeamMember('Marie Koné', 'marie.kone@email.com', 'Comptable'),
            _buildTeamMember('Pierre Dubois', 'pierre.dubois@email.com', 'Commercial'),
          ],
        ),
      ),
    );
  }

  Widget _buildTaxRulesTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Règles Fiscales', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _showAddTaxRuleDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nouvelle Règle'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: taxRules.length,
                itemBuilder: (context, index) {
                  final rule = taxRules[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(rule.name),
                      subtitle: Text('Taux: ${rule.rate}% • Compte: ${rule.accountNumber}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditTaxRuleDialog(rule),
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

  Widget _buildAdvancedTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paramètres Avancés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Text('Sauvegarde et Restauration', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.backup),
                  label: const Text('Sauvegarder les Données'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.restore),
                  label: const Text('Restaurer'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Journal d\'Audit', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.history),
              label: const Text('Voir le Journal d\'Audit'),
            ),
            const SizedBox(height: 24),
            const Text('Intégrations', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            const Text('API Keys et Webhooks (à configurer dans Supabase)'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Gérer les Intégrations'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String email, String role) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Text('$email • $role'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _saveCompanySettings() {
    // Save company settings logic would go here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paramètres entreprise enregistrés')),
    );
  }

  void _showInviteMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => const InviteMemberDialog(),
    );
  }

  void _showAddTaxRuleDialog() {
    showDialog(
      context: context,
      builder: (context) => const TaxRuleFormDialog(),
    ).then((newRule) {
      if (newRule != null) {
        setState(() {
          taxRules.add(newRule);
        });
      }
    });
  }

  void _showEditTaxRuleDialog(TaxRule rule) {
    showDialog(
      context: context,
      builder: (context) => TaxRuleFormDialog(taxRule: rule),
    ).then((updatedRule) {
      if (updatedRule != null) {
        setState(() {
          final index = taxRules.indexWhere((r) => r.name == rule.name);
          if (index != -1) {
            taxRules[index] = updatedRule;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _companyNameController.dispose();
    _rccmController.dispose();
    _nifController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

class InviteMemberDialog extends StatefulWidget {
  const InviteMemberDialog({super.key});

  @override
  State<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends State<InviteMemberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _role = 'Collaborateur';

  final List<String> roles = ['Admin', 'Comptable', 'RH/Paie', 'Commercial', 'Collaborateur', 'Consultant/Auditeur'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Inviter un Membre d\'Équipe'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value?.contains('@') ?? false ? null : 'Email invalide',
            ),
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Rôle'),
              items: roles.map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) => setState(() => _role = value!),
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
          onPressed: _sendInvitation,
          child: const Text('Envoyer l\'Invitation'),
        ),
      ],
    );
  }

  void _sendInvitation() {
    if (_formKey.currentState?.validate() ?? false) {
      // Send invitation logic would go here
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation envoyée à ${_emailController.text}')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

class TaxRuleFormDialog extends StatefulWidget {
  final TaxRule? taxRule;

  const TaxRuleFormDialog({super.key, this.taxRule});

  @override
  State<TaxRuleFormDialog> createState() => _TaxRuleFormDialogState();
}

class _TaxRuleFormDialogState extends State<TaxRuleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();
  final _accountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taxRule != null) {
      _nameController.text = widget.taxRule!.name;
      _rateController.text = widget.taxRule!.rate.toString();
      _accountController.text = widget.taxRule!.accountNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.taxRule == null ? 'Nouvelle Règle Fiscale' : 'Modifier Règle Fiscale'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom de la taxe'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
            ),
            TextFormField(
              controller: _rateController,
              decoration: const InputDecoration(labelText: 'Taux (%)'),
              keyboardType: TextInputType.number,
              validator: (value) => double.tryParse(value ?? '') == null ? 'Taux invalide' : null,
            ),
            TextFormField(
              controller: _accountController,
              decoration: const InputDecoration(labelText: 'N° Compte Comptable'),
              validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
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
          onPressed: _saveTaxRule,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }

  void _saveTaxRule() {
    if (_formKey.currentState?.validate() ?? false) {
      final taxRule = TaxRule(
        name: _nameController.text,
        rate: double.parse(_rateController.text),
        accountNumber: _accountController.text,
      );
      Navigator.of(context).pop(taxRule);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    _accountController.dispose();
    super.dispose();
  }
}

class TaxRule {
  final String name;
  final double rate;
  final String accountNumber;

  TaxRule({
    required this.name,
    required this.rate,
    required this.accountNumber,
  });
}