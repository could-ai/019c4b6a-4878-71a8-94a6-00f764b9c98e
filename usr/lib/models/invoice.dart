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
