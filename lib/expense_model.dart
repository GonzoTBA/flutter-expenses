class Expense {
  final int amount;
  final String description;
  final DateTime timestamp;

  Expense(this.amount, this.description, this.timestamp);

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      json['amount'],
      json['description'],
      DateTime.parse(json['timestamp']),
    );
  }
}
