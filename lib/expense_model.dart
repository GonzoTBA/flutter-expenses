class Expense {
  final int amount;
  final String description;
  final DateTime timestamp;
  final String? id;

  // Class constructor
  Expense({
    this.id,
    required this.amount,
    required this.description,
    required this.timestamp,
  });

    // Agregar un constructor de copia para actualizar el ID
  Expense copyWith({String? id, int? amount, String? description, DateTime? timestamp}) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toUtc().toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String?,
      amount: json['amount'] as int,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
