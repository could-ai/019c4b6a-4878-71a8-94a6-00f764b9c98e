class AccountingEntry {
  final String id;
  final int? entryNumber;
  final DateTime date;
  final String description;
  final String accountNumber;
  final String accountName;
  final double debit;
  final double credit;

  AccountingEntry({
    required this.id,
    this.entryNumber,
    required this.date,
    required this.description,
    required this.accountNumber,
    required this.accountName,
    required this.debit,
    required this.credit,
  });
}
