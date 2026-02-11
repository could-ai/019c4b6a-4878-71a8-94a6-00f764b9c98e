class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String type;
  final String status;
  final bool taxExemption;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.address = '',
    required this.type,
    required this.status,
    this.taxExemption = false,
  });
}

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

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String contractType;
  final DateTime hireDate;
  final double monthlySalary;
  final String status;
  final String? cnpsNumber;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.contractType,
    required this.hireDate,
    required this.monthlySalary,
    required this.status,
    this.cnpsNumber,
  });
}

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