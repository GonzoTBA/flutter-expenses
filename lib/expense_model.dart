class Expense {
  final int amount;
  final String description;
  final DateTime timestamp;

  // Class constructor
  Expense({
    required this.amount,
    required this.description,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['amount'] as int,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
