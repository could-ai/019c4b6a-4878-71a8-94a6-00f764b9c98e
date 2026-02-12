class Invoice {
  final String id;
  final String number;
  final String clientId;
  final String clientName;
  final DateTime date;
  final DateTime dueDate;
  final String status;
  final List<InvoiceItem> items;
  final double total;
  final double paidAmount;

  Invoice({
    required this.id,
    required this.number,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.dueDate,
    required this.status,
    required this.items,
    required this.total,
    required this.paidAmount,
  });

  Invoice copyWith({
    String? id,
    String? number,
    String? clientId,
    String? clientName,
    DateTime? date,
    DateTime? dueDate,
    String? status,
    List<InvoiceItem>? items,
    double? total,
    double? paidAmount,
  }) {
    return Invoice(
      id: id ?? this.id,
      number: number ?? this.number,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      items: items ?? this.items,
      total: total ?? this.total,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double price;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}
