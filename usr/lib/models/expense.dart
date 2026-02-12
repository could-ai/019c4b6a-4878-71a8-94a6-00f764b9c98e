class Expense {
  final String id;
  final String title;
  final String supplier;
  final DateTime date;
  final double amount;
  final double vatRate;
  final String category;
  final String paymentMethod;
  final double deductibleVat;
  final double proratedDeduction;
  final String? reference;

  Expense({
    required this.id,
    required this.title,
    required this.supplier,
    required this.date,
    required this.amount,
    required this.vatRate,
    required this.category,
    required this.paymentMethod,
    required this.deductibleVat,
    required this.proratedDeduction,
    this.reference,
  });
}
