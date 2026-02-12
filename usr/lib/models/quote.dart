class Quote {
  final String id;
  final String number;
  final String clientId;
  final String clientName;
  final DateTime date;
  final DateTime expiryDate;
  final String status;
  final List<QuoteItem> items;
  final double total;

  Quote({
    required this.id,
    required this.number,
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.expiryDate,
    required this.status,
    required this.items,
    required this.total,
  });
}

class QuoteItem {
  final String description;
  final int quantity;
  final double price;

  QuoteItem({
    required this.description,
    required this.quantity,
    required this.price,
  });
}
