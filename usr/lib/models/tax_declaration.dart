class TaxDeclaration {
  final String id;
  final String type;
  final String period;
  final String status;
  final double amount;
  final DateTime dueDate;
  final DateTime? paymentDate;

  TaxDeclaration({
    required this.id,
    required this.type,
    required this.period,
    required this.status,
    required this.amount,
    required this.dueDate,
    this.paymentDate,
  });

  TaxDeclaration copyWith({
    String? id,
    String? type,
    String? period,
    String? status,
    double? amount,
    DateTime? dueDate,
    DateTime? paymentDate,
  }) {
    return TaxDeclaration(
      id: id ?? this.id,
      type: type ?? this.type,
      period: period ?? this.period,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      paymentDate: paymentDate ?? this.paymentDate,
    );
  }
}
